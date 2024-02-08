//
//  UserNicknameViewModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2024/02/08.
//

import Foundation
import Combine

final class UserNicknameViewModel: ViewModel {
    
    struct Input {
        let textFieldSubject: PassthroughSubject<String, Never>
        let nextButtonTapped: PassthroughSubject<String, Never>
    }
    
    struct Output {
        let textFieldResult: AnyPublisher<SmeemButtonType, Never>
        let nextButtonResult: AnyPublisher<Void, Never>
        let nicknameDuplicateResult: AnyPublisher<Void, Never>
        let errorResult: AnyPublisher<SmeemError, Never>
        let loadingViewResult: AnyPublisher<Bool, Never>
    }
    
    private var cancelBag = Set<AnyCancellable>()
    private let errorSubject = PassthroughSubject<SmeemError, Never>()
    private let nicknameDuplicateSubject = PassthroughSubject<Void, Never>()
    private let loadingViewSubject = PassthroughSubject<Bool, Never>()
    
    func transform(input: Input) -> Output {
        let textFieldResult = input.textFieldSubject
            .compactMap{$0}
            .map { text in
                return self.vaildateText(text: text)
            }
            .eraseToAnyPublisher()
        
        let nextButtonResult = input.nextButtonTapped
            .handleEvents(receiveSubscription: { _ in
                self.loadingViewSubject.send(true)
            })
            .flatMap { text -> AnyPublisher<Void, Never> in
                return Future<Void, Never> { promise in
                    OnboardingAPI.shared.ninknameCheckAPI(userName: text,
                                                          accessToken: UserDefaultsManager.clientAccessToken) { result in
                        switch result {
                        case .success(let response):
                            // 중복이면 중복 subject
                            if response.isExist {
                                self.nicknameDuplicateSubject.send(())
                            } else {
                                promise(.success(()))
                            }
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
        
        let nicknameDuplicateResult = nicknameDuplicateSubject.eraseToAnyPublisher()
        let loadingViewResult = loadingViewSubject.eraseToAnyPublisher()
        let errorResult = errorSubject.eraseToAnyPublisher()
        
        return Output(textFieldResult: textFieldResult,
                      nextButtonResult: nextButtonResult,
                      nicknameDuplicateResult: nicknameDuplicateResult,
                      errorResult: errorResult,
                      loadingViewResult: loadingViewResult)
    }
}

extension UserNicknameViewModel {
    private func vaildateText(text: String) -> SmeemButtonType {
        if text.first == " " {
            return .notEnabled
        } else if text.filter({ $0 == " " }).count == text.count {
            return .notEnabled
        } else {
            return .enabled
        }
    }
}
