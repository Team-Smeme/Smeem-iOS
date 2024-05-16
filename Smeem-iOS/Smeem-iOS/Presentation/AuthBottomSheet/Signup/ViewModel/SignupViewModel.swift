//
//  SignupViewModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2/13/24.
//

import Foundation
import Combine

import KakaoSDKAuth
import KakaoSDKUser

final class SignupViewModel: ViewModel {
    
    private let provider = OnboardingService()
    
    struct Input {
        let kakaoLoginTapped: PassthroughSubject<Void, Never>
        let appleLoginSubject: PassthroughSubject<String, Never>
        let dismissTapped: PassthroughSubject<Void, Never>
        let userServiceSubject: PassthroughSubject<Void, Never>
        let homeSubject: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let presentHomeResult: AnyPublisher<Void, Never>
        let presentServiceResult: AnyPublisher<Void, Never>
        let loadingViewResult: AnyPublisher<Bool, Never>
        let errorResult: AnyPublisher<SmeemError, Never>
    }
    
    private let kakaoAppSubject = PassthroughSubject<Void, Never>()
    private let kakaoWebSubject = PassthroughSubject<Void, Never>()
    private let presentServiceResult = PassthroughSubject<Void, Never>()
    private let presentHomeResult = PassthroughSubject<Void, Never>()
    private let amplitudeSubject = PassthroughSubject<Void, Never>()
    private let loadingViewResult = PassthroughSubject<Bool, Never>()
    private let errorResult = PassthroughSubject<SmeemError, Never>()
    private let userServiceSubject = PassthroughSubject<Void, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    func transform(input: Input) -> Output {
        
        let kakaoLoginResult = input.kakaoLoginTapped
            .handleEvents(receiveSubscription: { _ in
                self.loadingViewResult.send(true)
            })
            .flatMap { _ -> AnyPublisher<AuthModel, Never> in
                return Future<AuthModel, Never> { promise in
                    if UserApi.isKakaoTalkLoginAvailable() {
                        self.loginKakaoWithApp { token in
                            token == nil ? self.errorResult.send(.serverError) :
                            promise(.success(AuthModel(accessToken: token!.accessToken,
                                                       type: "KAKAO")))
                        }
                    } else {
                        self.loginKakaoWithWeb { token in
                            token == nil ? self.errorResult.send(.serverError) :
                            promise(.success(AuthModel(accessToken: token!.accessToken,
                                                       type: "KAKAO")))
                        }
                    }
                }
                .handleEvents(receiveCompletion: { _ in
                    self.loadingViewResult.send(false)
                })
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let appleLoginResult = input.appleLoginSubject
            .map { token -> AuthModel in
                return AuthModel(accessToken: token, type: "APPLE")
            }
            .eraseToAnyPublisher()
        
        let presentHomeResult = Publishers.Merge(kakaoLoginResult, appleLoginResult)
            .handleEvents(receiveSubscription: { _ in
                self.loadingViewResult.send(true)
            })
            .map { model -> String in
                UserDefaultsManager.hasKakaoToken = model.type == "KAKAO" ? true : false
                UserDefaultsManager.socialToken = model.accessToken
                return model.type
            }
            .flatMap { type -> AnyPublisher<Void, Never> in
                return Future<Void, Never> { promise in
                    AuthAPI.shared.loginAPI(param: LoginRequest(social: type,
                                                                fcmToken: UserDefaultsManager.fcmToken)) { result in
                        switch result {
                        case .success(let response):
                            
                            UserDefaultsManager.clientAccessToken = response.accessToken
                            UserDefaultsManager.clientRefreshToken = response.refreshToken
                            
                            if response.hasPlan == false || (response.hasPlan == true && response.isRegistered == false) {
                                self.amplitudeSubject.send(())
                                self.userServiceSubject.send(())
                            } else {
                                // 계정이 있는 유저
                                UserDefaultsManager.accessToken = response.accessToken
                                UserDefaultsManager.refreshToken = response.refreshToken
                                
                                promise(.success(()))
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
        
        let userServiceResult = userServiceSubject.eraseToAnyPublisher()
        
        amplitudeSubject
            .sink { _ in
                AmplitudeManager.shared.track(event: AmplitudeConstant.Onboarding.signup_success.event)
            }
            .store(in: &cancelBag)
        
        let loadingViewResult = loadingViewResult.eraseToAnyPublisher()
        let errorResult = errorResult.eraseToAnyPublisher()
        
        return Output(presentHomeResult: presentHomeResult,
                      presentServiceResult: userServiceResult,
                      loadingViewResult: loadingViewResult,
                      errorResult: errorResult)
    }
}

extension SignupViewModel {
    private func loginKakaoWithApp(completion: @escaping (OAuthToken?) -> ()) {
        UserApi.shared.loginWithKakaoTalk { oAuthToken, error in
            guard let authToken = oAuthToken else {
                completion(nil)
                return
            }
            
            completion(authToken)
        }
    }
    
    private func loginKakaoWithWeb(completion: @escaping (OAuthToken?) -> Void) {
        UserApi.shared.loginWithKakaoAccount { oAuthToken, error in
            guard let authToken = oAuthToken else {
                completion(nil)
                return
            }
            
            completion(authToken)
        }
    }
}

