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
    
    struct Input {
        let kakaoLoginTapped: PassthroughSubject<Void, Never>
        let appleLoginSubject: PassthroughSubject<String, Never>
        let dismissTapped: PassthroughSubject<Void, Never>
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
    private let trainingPlanRequestSubject = PassthroughSubject<TrainingRequestModel, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    var trainingPlanRequest: TrainingPlanRequest?
    
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
                                
                                guard let request = self.trainingPlanRequest else { return }
                                self.trainingPlanRequestSubject.send(TrainingRequestModel(plan: request,
                                                                                          accessToken: response.accessToken))
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
        
        let presentServiceResult = trainingPlanRequestSubject
            .handleEvents(receiveSubscription: { _ in
                self.loadingViewResult.send(true)
            })
            .flatMap { request -> AnyPublisher<Void, Never> in
                return Future<Void, Never> { premise in
                    OnboardingService.shared.userPlanPathAPI(param: request.plan, accessToken: request.accessToken) { response in
                        switch response {
                        case .success(_):
                            UserDefaultsManager.clientAccessToken = request.accessToken
                            premise(.success(()))
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
        
        amplitudeSubject
            .sink { _ in
                AmplitudeManager.shared.track(event: AmplitudeConstant.Onboarding.signup_success.event)
            }
            .store(in: &cancelBag)
        
        let loadingViewResult = loadingViewResult.eraseToAnyPublisher()
        let errorResult = errorResult.eraseToAnyPublisher()
        
        return Output(presentHomeResult: presentHomeResult,
                      presentServiceResult: presentServiceResult,
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

