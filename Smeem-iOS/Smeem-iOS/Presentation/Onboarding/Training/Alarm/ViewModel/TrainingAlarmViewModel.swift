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
        let alarmTimeSubject: PassthroughSubject<AlarmTimeAppData, Never>
        let alarmDaySubject: PassthroughSubject<Set<String>, Never>
//        let laterButtonTapped: PassthroughSubject<UserPlanRequest, Never>
//        let completeButtonTapped: PassthroughSubject<UserPlanRequest, Never>
    }
    
    struct Output {
//        let bottomSheetResult: AnyPublisher<Void, Never>
//        let homeResult: AnyPublisher<Void, Never>
//        let alarmPopupResult: AnyPublisher<Void, Never>
//        let cellResult: AnyPublisher<Void, Never>
        let buttonTypeResult: AnyPublisher<SmeemButtonType, Never>
    }
    
    private var cancelBag = Set<AnyCancellable>()
    
    private var hour = 22
    private var minute = 0
    private var dayAndNight = "PM"
    private var dayList = "MON,TUE,WED,THU,FRI"
    
    func transform(input: Input) -> Output {
        input.alarmTimeSubject
            .sink(receiveValue: { data in
                self.hour = self.calculateHours(hour: data.hour, dayAndNight: data.dayAndNight)
                self.minute = data.minute == "00" ? 0 : 30
                
                print(self.hour)
                print(self.minute)
            })
            .store(in: &cancelBag)
        
        let buttonTypeResult = input.alarmDaySubject
            .map { dayArray in
                self.dayList = !dayArray.isEmpty ? Array(dayArray).joined(separator: ",") : ""
                print(self.dayList)
                return dayArray.isEmpty ? SmeemButtonType.notEnabled : SmeemButtonType.enabled
            }
            .eraseToAnyPublisher()
        
        return Output(buttonTypeResult: buttonTypeResult)
    }
    
    private func userPlanPatchAPI(userPlan: UserPlanRequest, accessToken: String) {
        SmeemLoadingView.showLoading()
//        OnboardingAPI.shared.userPlanPathAPI(param: userPlan, accessToken: accessToken) { result in
//
//            switch result {
//            case .success(_):
//                let userNicknameVC = UserNicknameViewController()
//                self.navigationController?.pushViewController(userNicknameVC, animated: true)
//            case .failure(let error):
//                self.showToast(toastType: .smeemErrorToast(message: error))
//            }
//
//            SmeemLoadingView.hideLoading()
//
//        }
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
