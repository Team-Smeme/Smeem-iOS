//
//  SplashViewModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2024/02/11.
//

import Foundation
import Combine

final class SplashViewModel: ViewModel {
    
    private let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    
    struct Input {
        let checkUpdatePopup: PassthroughSubject<Void, Never>
        let restartSubject: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let updatePopupResult: AnyPublisher<UpdateTextModel, Never>
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
    private let restartSubject = PassthroughSubject<Void, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    private var provider: SplashServiceProtocol
    
    init(provider: SplashServiceProtocol) {
        self.provider = provider
    }
    
    func transform(input: Input) -> Output {
        let updatePopupResult = input.checkUpdatePopup
            .handleEvents(receiveSubscription: { _ in
                self.loadingViewResult.send(true)
            })
            .delay(for: .seconds(0.5), scheduler: DispatchQueue.global())
            .flatMap { _ -> AnyPublisher<UpdateTextModel, Never> in
                return Future<UpdateTextModel, Never> { promise in
                    self.provider.updateGetAPI { result in
                        switch result {
                        case .success(let response):
                            if self.checkVersion(client: self.appVersion,
                                                 now: response.iosVersion.version,
                                                 force: response.iosVersion.forceVersion) {
                                
                                promise(.success(UpdateTextModel(title: response.title,
                                                                 content: response.content)))
                            } else {
                                UserDefaultsManager.accessToken != "" ? self.tokenCheckResult.send(()) :
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
        
        let homeStartResult = tokenCheckResult
            .handleEvents(receiveSubscription: { _ in
                self.loadingViewResult.send(true)
            })
            .flatMap { _ -> AnyPublisher<Void, Never> in
                return Future<Void, Never> { promise in
                    AuthService.shared.reLoginAPI() { result in
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
        let delayRestartSubject = input.restartSubject.delay(for: .seconds(1.5), scheduler: DispatchQueue.global())
        let smeemStartMergeResult = Publishers.Merge(smeemStartResult, delayRestartSubject).eraseToAnyPublisher()
        
        return Output(updatePopupResult: updatePopupResult,
                      homeStartResult: homeStartResult,
                      smeemStartResult: smeemStartMergeResult,
                      errorResult: errorResult,
                      loadingViewResult: loadingViewResult)
        
    }
}

extension SplashViewModel {
    func checkVersion(client: String, now: String, force: String) -> Bool {
        let clientVersion = client.split(separator: ".").map{$0}
        let nowVersion = now.split(separator: ".").map{$0}
        let forceVersion = force.split(separator: ".").map{$0}
        
        // force가 크고 현재 앱 버전이랑 now랑 다를 때 -> 강업
        if forceVersion[0] > clientVersion[0] && clientVersion != nowVersion {
            return true
        } else {
        // force가 크고, 현재 앱 버전이랑 now랑 같을 때 -> 강업하고 온 유저
        // force가 안 큼 -> 강업할 필요 없는 상태
            return false
        }
    }
}
    
