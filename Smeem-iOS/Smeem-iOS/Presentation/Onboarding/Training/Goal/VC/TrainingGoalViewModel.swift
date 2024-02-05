//
//  TrainingGoalViewModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2024/01/28.
//

import Foundation
import Combine

final class TrainingGoalViewModel {

    struct Input {
        let viewDidLoadSubject: PassthroughSubject<Void, Never>
        let cellTapped: PassthroughSubject<(String, SmeemButtonType), Never>
        let nextButtonTapped: PassthroughSubject<Void, Never>
        let amplitudeSubject: PassthroughSubject<Void, Never>
    }

    struct Output {
        let viewWillappearResult: AnyPublisher<[Plan], Never>
        let cellResult: AnyPublisher<SmeemButtonType, Never>
        let nextButtonResult: AnyPublisher<String, Never>
        let errorResult: AnyPublisher<SmeemError, Never>
        let loadingViewResult: AnyPublisher<Bool, Never>
    }
    
    private let errorSubject = PassthroughSubject<SmeemError, Never>()
    private let loadingViewSubject = PassthroughSubject<Bool, Never>()
    private var cancelbag = Set<AnyCancellable>()
    
    private var tempTarget = ""

    func transform(input: Input) -> Output {
        let viewDidLoadSubject = input.viewDidLoadSubject
            .map { _ in
                self.loadingViewSubject.send(true)
            }
            .flatMap { _ -> AnyPublisher<[Plan], Never> in
                return Future<[Plan], Never> { promise in
                    OnboardingAPI.shared.planList { result in
                        switch result {
                        case .success(let response):
                            promise(.success(response))
                            self.loadingViewSubject.send(false)
                        case .failure(let error):
                            self.errorSubject.send(error)
                            self.loadingViewSubject.send(false)
                        }
                    }
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let cellResult = input.cellTapped
            .map { target, buttonType in
                self.tempTarget = target
                return buttonType
            }
            .eraseToAnyPublisher()
        
        let nextButtonResult = input.nextButtonTapped
            .map { _ in
                return self.tempTarget
            }
            .eraseToAnyPublisher()
        
        input.amplitudeSubject
            .sink { _ in
                AmplitudeManager.shared.track(event: AmplitudeConstant.Onboarding.onboarding_goal_view.event)
            }
            .store(in: &cancelbag)
        
        let errorResult = errorSubject.eraseToAnyPublisher()
        let loadingViewResult = loadingViewSubject.eraseToAnyPublisher()
        
        return Output(viewWillappearResult: viewDidLoadSubject,
                      cellResult: cellResult,
                      nextButtonResult: nextButtonResult,
                      errorResult: errorResult,
                      loadingViewResult: loadingViewResult)
    }
}
