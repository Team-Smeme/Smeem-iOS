//
//  SplashViewModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2024/02/11.
//

import Foundation
import Combine

final class SplashViewModel: ViewModel {
    
    struct Input {
        let checkUpdatePopup: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let updatePopupResult: AnyPublisher<Void, Never>
        let homeStartResult: AnyPublisher<Void, Never>
        let smeemStartResult: AnyPublisher<Void, Never>
        let errorResult: AnyPublisher<SmeemError, Never>
        let loadingViewResult: AnyPublisher<Bool, Never>
    }
    
    private let loadingViewResult = PassthroughSubject<Bool, Never>()
    private let errorResult = PassthroughSubject<SmeemError, Never>()
    private let tokenCheckResult = PassthroughSubject<Void, Never>()
    private let homeStartResult = PassthroughSubject<Void, Never>()
    private let smeemStartResult = PassthroughSubject<Void, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    func transform(input: Input) -> Output {
        let updatePopupResult = input.checkUpdatePopup
            .handleEvents(receiveSubscription: { _ in
                self.loadingViewResult.send(true)
            })
            .delay(for: 0.5, scheduler: DispatchQueue.global())
//            .receive(on: RunLoop.main)
            .flatMap { _ -> AnyPublisher<Void, Never> in
                return Future<Void, Never> { promise in
                    Task {
                        do {
                            let appStoreVersion = try await System().latestVersion()!.split(separator: ".").map{$0}
                            let currentProjectVersion = System.appVersion!.split(separator: ".").map{$0}

                            // 업데이트 팝업 띄우기
                            if appStoreVersion[0] < currentProjectVersion[0] {
                                promise(.success(()))
                            } else {
                                UserDefaultsManager.accessToken != "" ? self.tokenCheckResult.send(()) :
                                                                        self.smeemStartResult.send(())
                            }
                        }
                    }
                }
                .handleEvents(receiveCompletion: { _ in
                    self.loadingViewResult.send(false)
                })
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let homeStartResult = tokenCheckResult
            .handleEvents(receiveSubscription: { _ in
                self.loadingViewResult.send(true)
            })
            .flatMap { _ -> AnyPublisher<Void, Never> in
                return Future<Void, Never> { promise in
                    AuthAPI.shared.reLoginAPI() { result in
                        switch result {
                        case .success(let response):
                            
                            if response.success {
                                if let accessToken = response.data?.accessToken {
                                    UserDefaultsManager.accessToken = accessToken
                                }
                                if let refresToken = response.data?.accessToken {
                                    UserDefaultsManager.refreshToken = refresToken
                                }
                                promise(.success(()))
                            // 토큰 만료
                            } else if !response.success {
                                self.smeemStartResult.send(())
                            }
                        case .failure(let error):
                            self.errorResult.send(error)
                        }
                    }
                }
                .handleEvents(receiveCompletion: { _ in
                    self.loadingViewResult.send(false)
                })
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let errorResult = errorResult.eraseToAnyPublisher()
        let smeemStartResult = smeemStartResult.eraseToAnyPublisher()
        let loadingViewResult = loadingViewResult.eraseToAnyPublisher()
        
        return Output(updatePopupResult: updatePopupResult,
                      homeStartResult: homeStartResult,
                      smeemStartResult: smeemStartResult,
                      errorResult: errorResult,
                      loadingViewResult: loadingViewResult)
        
    }
}
    
