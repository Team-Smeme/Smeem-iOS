//
//  TrainingPlanViewModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 5/1/24.
//

import Foundation
import Combine

final class TrainingPlanViewModel: ViewModel {
    
    struct Input {
        let viewWillappearSubject: PassthroughSubject<Void, Never>
        let cellTapped: PassthroughSubject<(Int, SmeemButtonType), Never>
        let nextButtonTapped: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let viewWillappearResult: AnyPublisher<[Plans], Never>
        let cellResult: AnyPublisher<SmeemButtonType, Never>
        let nextButtonResult: AnyPublisher<(String, Int), Never>
        let errorResult: AnyPublisher<SmeemError, Never>
        let loadingViewResult: AnyPublisher<Bool, Never>
    }
    
    private let errorSubject = PassthroughSubject<SmeemError, Never>()
    private let loadingViewSubject = PassthroughSubject<Bool, Never>()
    private var cancelbag = Set<AnyCancellable>()
    private var provider = OnboardingService()
    
    var target = ""
    var planId = 1
    
    func transform(input: Input) -> Output {
        let viewWillAppearResult = input.viewWillappearSubject
            .flatMap { _ -> AnyPublisher<[Plans], Never> in
                self.loadingViewSubject.send(true)
                return Future<[Plans], Never> { promise in
                    self.provider.trainingPlanGETAPI { result in
                        switch result {
                        case .success(let response):
                            self.loadingViewSubject.send(false)
                            promise(.success(response))
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
                self.planId = id
                return buttonType
            }
            .eraseToAnyPublisher()
        
        let nextButtonResult = input.nextButtonTapped
            .map { _ in
                return (self.target, self.planId)
            }
            .eraseToAnyPublisher()
        
        let loadingViewResult = loadingViewSubject.eraseToAnyPublisher()
        
        let errorResult = errorSubject
            .map { smeemError in
                self.loadingViewSubject.send(false)
                return smeemError
            }
            .eraseToAnyPublisher()
        
        
        return Output(viewWillappearResult: viewWillAppearResult,
                      cellResult: cellResult,
                      nextButtonResult: nextButtonResult,
                      errorResult: errorResult,
                      loadingViewResult: loadingViewResult)
    }
}
