//
//  TrainingAlarmViewModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2024/02/07.
//

import Foundation
import Combine

final class TrainingAlarmViewModel: ViewModel {
    
    struct Input {
        let viewWillAppearSubject: PassthroughSubject<Void, Never>
        let alarmTimeSubject: PassthroughSubject<AlarmTimeAppData, Never>
        let alarmDaySubject: PassthroughSubject<Set<String>, Never>
        let alarmButtonTapped: PassthroughSubject<AlarmType, Never>
        let nextFlowSubject: PassthroughSubject<Void, Never>
        let amplitudeSubject: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let buttonTypeResult: AnyPublisher<SmeemButtonType, Never>
        let alarmResult: AnyPublisher<Void, Never>
        let bottomSheetResult: AnyPublisher<TrainingPlanRequest, Never>
        let nicknameResult: AnyPublisher<Void, Never>
        let errorResult: AnyPublisher<SmeemError, Never>
        let loadingViewResult: AnyPublisher<Bool, Never>
    }
    
    private var cancelBag = Set<AnyCancellable>()
    private let bottomSheetSubject = PassthroughSubject<Void, Never>()
    private let nicknameSubject = PassthroughSubject<Void, Never>()
    private let errorSubject = PassthroughSubject<SmeemError, Never>()
    private let loadingViewSubject = PassthroughSubject<Bool, Never>()
    
    var target = ""
    var trainingPlanRequest = TrainingPlanRequest(target: "DEVELOP",
                                                  trainingTime: TrainingTime(day: "MON,TUE,WED,THU,FRI",
                                                                             hour: 22,
                                                                             minute: 0),
                                                  hasAlarm: true)
    var authType = AuthType.signup
    private var provider: OnboardingServiceProtocol
    
    init(provider: OnboardingServiceProtocol) {
        self.provider = provider
    }
    
    func transform(input: Input) -> Output {
        input.viewWillAppearSubject
            .sink { _ in
                self.authType = UserDefaultsManager.clientAuthType == self.authType.rawValue ? .signup : .login
                self.trainingPlanRequest.target = self.target
            }
            .store(in: &cancelBag)
            
        input.alarmTimeSubject
            .sink(receiveValue: { data in
                let hour = self.calculateHours(hour: data.hour, dayAndNight: data.dayAndNight)
                let minute = data.minute == "00" ? 0 : 30
                self.trainingPlanRequest.trainingTime.hour = hour
                self.trainingPlanRequest.trainingTime.minute = minute
            })
            .store(in: &cancelBag)
        
        let buttonTypeResult = input.alarmDaySubject
            .map { dayArray in
                let dayList = !dayArray.isEmpty ? Array(dayArray).joined(separator: ",") : ""
                self.trainingPlanRequest.trainingTime.day = dayList
                return dayArray.isEmpty ? SmeemButtonType.notEnabled : SmeemButtonType.enabled
            }
            .eraseToAnyPublisher()
        
        let alarmResult = input.alarmButtonTapped
            .map { type in
                self.trainingPlanRequest.hasAlarm = type == .alarmOn ? true : false
            }
            .eraseToAnyPublisher()
        
        input.nextFlowSubject
            .sink { _ in
                // 시작하기 버튼 눌러서 시작한 유저 - 바텀시트 띄워 줘야 함
                if self.authType == .signup {
                    self.bottomSheetSubject.send(())
                } else {
                    // 앞에서 로그인하고 온 유서 - 닉네임 뷰로 이동
                    self.nicknameSubject.send(())
                }
            }
            .store(in: &cancelBag)
        
        let bottomSheetResult = bottomSheetSubject
            .map { _ in
                return self.trainingPlanRequest
            }
            .eraseToAnyPublisher()
        
        let nicknameResult = nicknameSubject
            .handleEvents(receiveSubscription: { _ in
                self.loadingViewSubject.send(true)
            })
            .flatMap { _ -> AnyPublisher<Void, Never> in
                return Future<Void, Never> { promise in
                    // 온보딩 이탈 가능성 있기 때문에 clinetAccessToken 값 저장
                    self.provider.userPlanPathAPI(param: self.trainingPlanRequest,
                                                  accessToken: UserDefaultsManager.clientAccessToken) { result in
                        
                        switch result {
                        case .success(let response):
                            promise(.success(()))
                        case .failure(let error):
                            self.errorSubject.send(error)
                        }
                    }
                }
                .handleEvents(receiveCompletion: { _ in
                    self.loadingViewSubject.send(false)
                })
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        input.amplitudeSubject
            .sink { _ in
                AmplitudeManager.shared.track(event: AmplitudeConstant.Onboarding.onboarding_alarm_view.event)
            }
            .store(in: &cancelBag)
        
        let errorResult = errorSubject.eraseToAnyPublisher()
        let loadingResult = loadingViewSubject.eraseToAnyPublisher()
        
        return Output(buttonTypeResult: buttonTypeResult,
                      alarmResult: alarmResult,
                      bottomSheetResult: bottomSheetResult,
                      nicknameResult: nicknameResult,
                      errorResult: errorResult,
                      loadingViewResult: loadingResult)
    }
    
    func calculateHours(hour: String, dayAndNight: String) -> Int {
        if dayAndNight == "PM" {
            // 12 PM 그대로, 13 ~ 23시까지
            return hour == "12" ? 12 : Int(hour)!+12
        } else {
            // AM 00:00
            return hour == "12" ? 24 : Int(hour)!
        }
    }
}
