//
//  TrainingWayViewModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2024/02/07.
//

import Foundation
import Combine

final class TrainingWayViewModel: ViewModel {
    
    struct Input {
        let viewWillAppearSubject: PassthroughSubject<Void, Never>
        let nextButtonTapped: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let viewWillAppearResult: AnyPublisher<TrainingWayAppData, Never>
        let nextButtonResult: AnyPublisher<String, Never>
        let errorResult: AnyPublisher<SmeemError, Never>
        let loadingViewResult: AnyPublisher<Bool, Never>
    }
    
    private let errorSubject = PassthroughSubject<SmeemError, Never>()
    private let loadingViewSubject = PassthroughSubject<Bool, Never>()
    private let provider = OnboardingService()
    
    var target = ""
    
    func transform(input: Input) -> Output {
        let viewWillAppearResult = input.viewWillAppearSubject
            .handleEvents(receiveSubscription: { _ in
                self.loadingViewSubject.send(true)
            })
            .flatMap { _ -> AnyPublisher<TrainingWayAppData, Never> in
                return Future<TrainingWayAppData, Never> { promise in
                    self.provider.trainingWayGetAPI(param: self.target) { result in
                        switch result {
                        case .success(let response):
                            let appData = self.configureWayData(training: response)
                            promise(.success(appData))
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
        
        let nextButtonResult = input.nextButtonTapped
            .map { _ in
                return self.target
            }
            .eraseToAnyPublisher()
        
        let errorResult = errorSubject.eraseToAnyPublisher()
        let loadingViewResult = loadingViewSubject.eraseToAnyPublisher()
        
        return Output(viewWillAppearResult: viewWillAppearResult,
                      nextButtonResult: nextButtonResult,
                      errorResult: errorResult,
                      loadingViewResult: loadingViewResult)
    }
    
    private func configureWayData(training: TrainingWayResponse) -> TrainingWayAppData {
        let wayTitle = training.name
        let wayArray = training.way.components(separatedBy: " 이상 ")
        let wayOne = wayArray[0] + " 이상"
        let wayTwo = wayArray[1]
        let detailWay = training.detail.split(separator: "\n").map{String($0)}
        let detailWayOne = detailWay[0]
        let detailWayTwo = detailWay[1]
        
        return TrainingWayAppData(wayTitle: wayTitle,
                                  wayOne: wayOne,
                                  wayTwo: wayTwo,
                                  detailWayOne: detailWayOne,
                                  detailWayTwo: detailWayTwo)
    }
}
