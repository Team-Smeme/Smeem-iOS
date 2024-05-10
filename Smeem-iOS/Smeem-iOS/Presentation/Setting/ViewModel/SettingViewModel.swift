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
        let pushButtonTapped: PassthroughSubject<Void, Never>
        let nicknameButtonTapped: PassthroughSubject<Void, Never>
        let planButtonTapped: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let pushButtonResult: AnyPublisher<Bool, Never>
        let hasPlanResult: AnyPublisher<SettingAppData, Never>
        let hasNotPlanResult: AnyPublisher<SettingAppData, Never>
        let nicknameResult: AnyPublisher<String, Never>
        let planButtonResult: AnyPublisher<Plans?, Never>
    }
    
    private var cancelBag = Set<AnyCancellable>()
    private let errorSubject = PassthroughSubject<SmeemError, Never>()
    private let loadingViewSubject = PassthroughSubject<Bool, Never>()
    
    private let settingAppDataSubject = PassthroughSubject<SettingResponse, Never>()
    private let hasPlanSubject = PassthroughSubject<SettingAppData, Never>()
    private let hasNotPlanSubject = PassthroughSubject<SettingAppData, Never>()
    
    func transform(input: Input) -> Output {
        let viewWillAppearResult = input.viewWillAppearSubject
            .flatMap { _ -> AnyPublisher<SettingResponse, Never> in
                self.loadingViewSubject.send(true)
                return Future<SettingResponse, Never> { promise in
                    self.provider.settingGetAPI { result in
                        switch result {
                        case .success(let response):
                            self.settingAppDataSubject.send(response)
                            promise(.success(response))
                        case .failure(let error):
                            self.errorSubject.send(error)
                        }
                    }
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let pushButtonResult = input.pushButtonTapped
            .flatMap { _ -> AnyPublisher<Bool, Never> in
                self.loadingViewSubject.send(true)
                return Future<Bool, Never> { promise in
                    guard let hasAlarm = self.settingData?.hasPushAlarm else { return }
                    self.provider.editPushAPI(param: EditPushRequest(hasAlarm: hasAlarm)) { result in
                        switch result {
                        case .success(_):
                            self.loadingViewSubject.send(false)
                            self.settingData?.hasPushAlarm = !hasAlarm
                            promise(.success(!hasAlarm))
                        case .failure(let error):
                            self.errorSubject.send(error)
                        }
                    }
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let _ = self.settingAppDataSubject
            .sink { response -> Void in
                var indexPathArray: [IndexPath] = []
                let dayArray = response.trainingTime.day.split(separator: ",")
                for i in 0..<dayArray.count {
                    indexPathArray.append(self.myPageSelectedIndexPath[String(dayArray[i])]!)
                }
                
                self.settingData = SettingAppData(nickname: response.username,
                                                  plan: response.trainingPlan,
                                                  hasPushAlarm: response.hasPushAlarm,
                                                  alarmIndexPath: indexPathArray)
                guard let settingData = self.settingData else { return }
                if let _ = settingData.plan {
                    self.hasPlanSubject.send(settingData)
                } else {
                    self.hasNotPlanSubject.send(settingData)
                }
            }
            .store(in: &cancelBag)
        
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
        
        return Output(pushButtonResult: pushButtonResult,
                      hasPlanResult: hasPlanResult,
                      hasNotPlanResult: hasNotPlanResult,
                      nicknameResult: nicknameResult,
                      planButtonResult: planButtonResult)
    }
}
