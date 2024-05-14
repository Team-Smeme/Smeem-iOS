//
//  EditPlanViewModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 5/9/24.
//

import Foundation
import Combine

final class EditPlanViewModel: ViewModel {
    
    var planId: Int?
    
    struct Input {
        let viewDidLoadSubject: PassthroughSubject<Void, Never>
        let cellTapped: PassthroughSubject<(Int, SmeemButtonType), Never>
        let completeButtonTapped: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let hasPlanResult: AnyPublisher<([Plans], Int?, SmeemButtonType), Never>
        let cellResult: AnyPublisher<SmeemButtonType, Never>
        let completeResult: AnyPublisher<Void, Never>
        let loadingViewResult: AnyPublisher<Bool, Never>
        let errorResult: AnyPublisher<SmeemError, Never>
    }
    
    private let onboardingProvider = OnboardingService()
    private let settingProvider = SettingService()
    private let errorSubject = PassthroughSubject<SmeemError, Never>()
    private let loadingViewSubject = PassthroughSubject<Bool, Never>()
    var cancelBag = Set<AnyCancellable>()
    
    func transform(input: Input) -> Output {
        let hasPlanResult = input.viewDidLoadSubject
            .flatMap { _ -> AnyPublisher<([Plans], Int?, SmeemButtonType), Never> in
                return Future<([Plans], Int?, SmeemButtonType), Never> { promise in
                    self.onboardingProvider.trainingPlanGETAPI { result in
                        switch result {
                        case .success(let response):
                            let buttonType = self.planId == nil ? SmeemButtonType.notEnabled : SmeemButtonType.enabled
                            promise(.success((response, self.planId, buttonType)))
                        case .failure(let error):
                            self.errorSubject.send(error)
                        }
                    }
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let cellResult = input.cellTapped
            .map { id, buttonType in
                self.planId = id+1
                return buttonType
            }
            .eraseToAnyPublisher()
        
        let completeResult = input.completeButtonTapped
            .flatMap { _ -> AnyPublisher<Void, Never> in
                return Future<Void, Never> { promise in
                    self.settingProvider.editPlanPatchAPI(param: PlanIdRequest(planId: self.planId!)) { result in
                        switch result {
                        case .success(_):
                            promise(.success(()))
                        case .failure(let error):
                            self.errorSubject.send(error)
                        }
                    }
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let errorResult = errorSubject.eraseToAnyPublisher()
        let loadingViewResult = loadingViewSubject.eraseToAnyPublisher()
        
        return Output(hasPlanResult: hasPlanResult,
                      cellResult: cellResult,
                      completeResult: completeResult,
                      loadingViewResult: loadingViewResult,
                      errorResult: errorResult)
    }
}
