//
//  SettingViewModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 5/7/24.
//

import Foundation
import Combine

final class SettingViewModel: ViewModel {
    
    private let myPageSelectedIndexPath = ["MON": IndexPath(item: 0, section: 0), "TUE":IndexPath(item: 1, section: 0), "WED":IndexPath(item: 2, section: 0), "THU":IndexPath(item: 3, section: 0), "FRI":IndexPath(item: 4, section: 0), "SAT":IndexPath(item: 5, section: 0), "SUN":IndexPath(item: 6, section: 0)]
    private var indexPathArray: [IndexPath] = []
    private var settingData: SettingAppData?
    
    var provider: SettingServiceProtocol!
    
    init(provider: SettingServiceProtocol) {
        self.provider = provider
    }
    
    struct Input {
        let viewWillAppearSubject: PassthroughSubject<Void, Never>
        let alarmToggleSubject: PassthroughSubject<Void, Never>
        let nicknameButtonTapped: PassthroughSubject<Void, Never>
        let planButtonTapped: PassthroughSubject<Void, Never>
        let alarmButtonTapped: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let alarmToggleResult: AnyPublisher<Bool, Never>
        let hasPlanResult: AnyPublisher<SettingAppData, Never>
        let hasNotPlanResult: AnyPublisher<SettingAppData, Never>
        let nicknameResult: AnyPublisher<String, Never>
        let planButtonResult: AnyPublisher<Plans?, Never>
        let alarmButtonResult: AnyPublisher<([IndexPath], TrainingTime), Never>
        let loadingViewResult: AnyPublisher<Bool, Never>
        let errorResult: AnyPublisher<SmeemError, Never>
    }
    
    private var cancelBag = Set<AnyCancellable>()
    private let errorSubject = PassthroughSubject<SmeemError, Never>()
    private let loadingViewSubject = PassthroughSubject<Bool, Never>()
    private let hasPlanSubject = PassthroughSubject<SettingAppData, Never>()
    private let hasNotPlanSubject = PassthroughSubject<SettingAppData, Never>()
    
    func transform(input: Input) -> Output {
        let viewWillAppearResult = input.viewWillAppearSubject
            .handleEvents(receiveSubscription: { _ in
                self.loadingViewSubject.send(true)
            })
            .flatMap { _ -> AnyPublisher<SettingResponse, Never> in
                return Future<SettingResponse, Never> { promise in
                    self.provider.settingGetAPI { result in
                        switch result {
                        case .success(let response):
                            promise(.success(response))
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
        
        let pushButtonResult = input.alarmToggleSubject
            .handleEvents(receiveSubscription: { _ in
                self.loadingViewSubject.send(true)
            })
            .flatMap { _ -> AnyPublisher<Bool, Never> in
                return Future<Bool, Never> { promise in
                    guard let hasAlarm = self.settingData?.hasPushAlarm else { return }
                    self.provider.editPushAPI(param: EditPushRequest(hasAlarm: !hasAlarm)) { result in
                        switch result {
                        case .success(_):
                            print(!hasAlarm)
                            self.settingData?.hasPushAlarm = !hasAlarm
                            promise(.success(!hasAlarm))
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
        
        viewWillAppearResult
            .sink { response in
                var indexPathArray: [IndexPath] = []
                let dayArray = response.trainingTime.day.split(separator: ",")
                for i in 0..<dayArray.count {
                    indexPathArray.append(self.myPageSelectedIndexPath[String(dayArray[i])]!)
                }
                
                self.settingData = SettingAppData(nickname: response.username,
                                                  plan: response.trainingPlan,
                                                  hasPushAlarm: response.hasPushAlarm,
                                                  alarmTime: TrainingTime(day: response.trainingTime.day,
                                                                          hour: response.trainingTime.hour,
                                                                          minute: response.trainingTime.minute),
                                                  alarmIndexPath: indexPathArray)
                guard let settingData = self.settingData else { return }
                if let _ = self.settingData?.plan {
                    self.hasPlanSubject.send(settingData)
                } else {
                    self.hasNotPlanSubject.send(settingData)
                }
            }
            .store(in: &cancelBag)
        
        let hasPlanResult = self.hasPlanSubject.eraseToAnyPublisher()
        let hasNotPlanResult = self.hasNotPlanSubject.eraseToAnyPublisher()
        
        let nicknameResult = input.nicknameButtonTapped
            .map { _ -> String in
                guard let nickname = self.settingData?.nickname else { return "정요니" }
                return nickname
            }
            .eraseToAnyPublisher()
        
        let planButtonResult = input.planButtonTapped
            .map { _ -> Plans? in
                if self.settingData?.plan == nil {
                    return nil
                } else {
                    return self.settingData?.plan
                }
            }
            .eraseToAnyPublisher()
        
        let alarmButtonResult = input.alarmButtonTapped
            .map { _ -> ([IndexPath], TrainingTime) in
                guard let data = self.settingData else { return (SettingAppData.empty.alarmIndexPath, SettingAppData.empty.alarmTime) }
                return (data.alarmIndexPath, TrainingTime(day: data.alarmTime.day,
                                                          hour: data.alarmTime.hour,
                                                          minute: data.alarmTime.minute))
            }
            .eraseToAnyPublisher()
        
        let loadingViewResult = loadingViewSubject.eraseToAnyPublisher()
        let errorResult = errorSubject.eraseToAnyPublisher()
        
        return Output(alarmToggleResult: pushButtonResult,
                      hasPlanResult: hasPlanResult,
                      hasNotPlanResult: hasNotPlanResult,
                      nicknameResult: nicknameResult,
                      planButtonResult: planButtonResult,
                      alarmButtonResult: alarmButtonResult,
                      loadingViewResult: loadingViewResult,
                      errorResult: errorResult)
    }
}
