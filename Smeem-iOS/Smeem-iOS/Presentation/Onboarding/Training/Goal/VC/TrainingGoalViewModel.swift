//
//  TrainingGoalViewModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2024/01/28.
//

//import Foundation
//import Combine
//
//final class TrainingGoalViewModel: ViewModel {
//
//    struct Input {
//        let viewDidLoadSubject: PassthroughSubject<Void, Error>
//        let cellTapped: PassthroughSubject<(String, SmeemButtonType), Error>
//        let nextButtonTapped: PassthroughSubject<String, Error>
//    }
//
//    struct Output {
//        let viewDidLoadResult: AnyPublisher<[Plan], Error>
//        let cellTappedResult: AnyPublisher<(String, SmeemButtonType), Error>
//        let nextButtonTapped: AnyPublisher<String, Error>
//    }
//
//    func transform(input: Input) -> Output {
//        let viewDidLoadResult = input.viewDidLoadSubject
//            .flatMap { [weak self] _ in
//
//                }
//                .eraseToAnyPublisher()
//            }
//    }
//
//    func planListGetAPI() {
//        SmeemLoadingView.showLoading()
//        OnboardingAPI.shared.planList() { response in
//
//            switch response {
//            case .success(let response):
//                self.trainingGoalCollectionView.planGoalArray = response.goals
//            case .failure(let error):
//                self.showToast(toastType: .smeemErrorToast(message: error))
//            }
//
//            SmeemLoadingView.hideLoading()
//        }
//    }
//}
