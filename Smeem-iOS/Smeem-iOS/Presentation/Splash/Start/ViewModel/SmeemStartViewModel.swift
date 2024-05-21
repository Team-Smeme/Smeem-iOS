//
//  SmeemStartViewModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2024/02/11.
//

import Foundation
import Combine

final class SmeemStartViewModel: ViewModel {
    
    struct Input {
        let loginButtonTapped: PassthroughSubject<Void, Never>
        let startButtonTapped: PassthroughSubject<Void, Never>
        let amplitudeSubject: PassthroughSubject<Void, Never>
        let trainingStartSubject: PassthroughSubject<Void, Never>
        let userServiceSubject: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let loginButtonTapped: AnyPublisher<Void, Never>
        let trainingStartResult: AnyPublisher<Void, Never>
        let userServiceResult: AnyPublisher<Void, Never>
    }
    
    private var cancelBag = Set<AnyCancellable>()
    
    func transform(input: Input) -> Output {
        let loginButtonResult = input.loginButtonTapped
            .map { _ in
                UserDefaultsManager.clientAuthType = AuthType.login.rawValue
            }
            .eraseToAnyPublisher()
        
        let startButtonTapped = input.startButtonTapped
            .map { _ in
                UserDefaultsManager.clientAuthType = AuthType.signup.rawValue
            }
            .eraseToAnyPublisher()
        
        input.amplitudeSubject
            .sink { _ in
                AmplitudeManager.shared.track(event: AmplitudeConstant.Onboarding.first_view.event)
            }
            .store(in: &cancelBag)
        
        let trainingStartSubject = input.trainingStartSubject.eraseToAnyPublisher()
        let trainingStartResult = Publishers.Merge(startButtonTapped, trainingStartSubject).eraseToAnyPublisher()
        
        let userServiceResult = input.userServiceSubject.eraseToAnyPublisher()
        
        return Output(loginButtonTapped: loginButtonResult,
                      trainingStartResult: trainingStartResult,
                      userServiceResult: userServiceResult)
    }
    
}
