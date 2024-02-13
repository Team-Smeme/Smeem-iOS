//
//  LoginViewModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2024/02/11.
//

import Foundation
import Combine

import KakaoSDKAuth
import KakaoSDKUser

struct LoginModel {
    let accessToken: String
    let type: String
}

final class LoginViewModel: ViewModel {
    
    struct Input {
        let kakaoLoginTapped: PassthroughSubject<Void, Never>
        let appleLoginSubject: PassthroughSubject<String, Never>
        let dismissTapped: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let presentTrainingResult: AnyPublisher<Void, Never>
        let presentServiceResult: AnyPublisher<Void, Never>
        let presentHomeResult: AnyPublisher<Void, Never>
        let loadingViewResult: AnyPublisher<Bool, Never>
        let errorResult: AnyPublisher<SmeemError, Never>
    }
    
    private let kakaoAppSubject = PassthroughSubject<Void, Never>()
    private let kakaoWebSubject = PassthroughSubject<Void, Never>()
    private let presentTrainingResult = PassthroughSubject<Void, Never>()
    private let presentServiceResult = PassthroughSubject<Void, Never>()
    private let presentHomeResult = PassthroughSubject<Void, Never>()
    private let loadingViewResult = PassthroughSubject<Bool, Never>()
    private let errorResult = PassthroughSubject<SmeemError, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    func transform(input: Input) -> Output {
        
        let kakaoLoginResult = input.kakaoLoginTapped
            .handleEvents(receiveSubscription: { _ in
                self.loadingViewResult.send(true)
            })
            .flatMap { _ -> AnyPublisher<LoginModel, Never> in
                return Future<LoginModel, Never> { promise in
                    if UserApi.isKakaoTalkLoginAvailable() {
                        self.loginKakaoWithApp { token in
                            token == nil ? self.errorResult.send(.serverError) :
                            promise(.success(LoginModel(accessToken: token!.accessToken,
                                                        type: "KAKAO")))
                        }
                    } else {
                        self.loginKakaoWithWeb { token in
                            token == nil ? self.errorResult.send(.serverError) :
                            promise(.success(LoginModel(accessToken: token!.accessToken,
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
            .map { token -> LoginModel in
                return LoginModel(accessToken: token, type: "APPLE")
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
                            
                            if response.hasPlan == false {
                                self.presentTrainingResult.send(())
                            } else if response.hasPlan == true && response.isRegistered == false {
                                self.presentServiceResult.send(())
                            } else {
                                // 삭제했다가 로그인한 유저 홈으로 이동
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
        
        let presentTrainingResult = presentTrainingResult.eraseToAnyPublisher()
        let presentServiceResult = presentServiceResult.eraseToAnyPublisher()
        let loadingViewResult = loadingViewResult.eraseToAnyPublisher()
        let errorResult = errorResult.eraseToAnyPublisher()
        
        return Output(presentTrainingResult: presentTrainingResult,
                      presentServiceResult: presentServiceResult,
                      presentHomeResult: presentHomeResult,
                      loadingViewResult: loadingViewResult,
                      errorResult: errorResult)
    }
    
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
