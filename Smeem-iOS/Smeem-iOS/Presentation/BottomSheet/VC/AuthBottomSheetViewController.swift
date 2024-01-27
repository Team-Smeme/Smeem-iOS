//
//  BottomSheetViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/06.
//

import UIKit

import SnapKit

import AuthenticationServices
import KakaoSDKAuth
import KakaoSDKUser

enum AuthType: String {
    case login
    case signup
}

final class BottomSheetViewController: UIViewController, LoginDelegate {
    
    private var hasPlan = false
    private var isRegistered = false
    private var badges: [Badges] = []
    
    private var kakaoAccessToken: String? {
        didSet {
            guard let kakaoAccessToken = self.kakaoAccessToken else {
                print("⭐️⭐️⭐️ 언래핑 실패했을 경우 ⭐️⭐️⭐️")
                return
            }
            
            UserDefaultsManager.socialToken = self.kakaoAccessToken!
            UserDefaultsManager.hasKakaoToken = true
            self.loginAPI(socialParam: "KAKAO")
        }
    }
    
    private var appleAccessToken: String? {
        didSet {
            guard let appleAccessToken = self.appleAccessToken else {
                print("⭐️⭐️⭐️ 언래핑 실패했을 경우 ⭐️⭐️⭐️")
                return
            }
            
            UserDefaultsManager.socialToken = self.appleAccessToken!
            UserDefaultsManager.hasKakaoToken = false
            self.loginAPI(socialParam: "APPLE")
        }
    }

    // MARK: - Property
    
    var defaultLoginHeight: CGFloat = 282
    var defaultSignUpHeight: CGFloat = 394
    
    var popupBadgeData: [PopupBadge]?
    var userPlanRequest: UserPlanRequest?
    
    var authType: AuthType = .login
    
    // MARK: - UI Property
    
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(red: 0.09, green: 0.09, blue: 0.086, alpha: 0.65).cgColor
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmedViewDidTap)))
        return view
    }()
    
    var bottomSheetView: BottomSheetView = {
        let view = BottomSheetView()
        view.viewType = .signUp
        return view
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        setLayout()
        setBottomViewDelegate()
    }
    
    // MARK: - @objc
    
    @objc func dimmedViewDidTap() {
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomSheetView.frame.origin.y = self.view.frame.height
        }) { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    // MARK: - Custom Method
    
    func kakaoLoginDataSend() {
        if UserApi.isKakaoTalkLoginAvailable() {
            loginKakaoWithApp()
        } else {
            loginKakaoWithWeb()
        }
    }
    
    func appleLoginDataSend() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = []
          
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func dismissBottomSheet() {
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomSheetView.frame.origin.y = self.view.frame.height
        }) { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    private func loginKakaoWithApp() {
        UserApi.shared.loginWithKakaoTalk { oAuthToken, error in
            if let _ = error {
                print("⭐️⭐️⭐️ 에러 발생 ⭐️⭐️⭐️")
                return
            }
            
            print("Login with KAKAO App Success !!")
            
            self.kakaoAccessToken = oAuthToken?.accessToken
            guard let refreshToken = oAuthToken?.refreshToken else { return }
            UserDefaultsManager.kakaoRefreushToken = refreshToken
        }
    }
    
    private func loginKakaoWithWeb() {
        UserApi.shared.loginWithKakaoAccount { oAuthToken, error in
            if let _ = error {
                print("⭐️⭐️⭐️ 에러 발생 ⭐️⭐️⭐️")
                return
            }
            
            print("Login with KAKAO App Success !!")
            
            self.kakaoAccessToken = oAuthToken?.accessToken
            guard let refreshToken = oAuthToken?.refreshToken else { return }
            UserDefaultsManager.kakaoRefreushToken = refreshToken
        }
    }

    private func setBottomViewDelegate() {
        self.bottomSheetView.delegate = self
    }
    
    private func setBackgroundColor() {
        view.backgroundColor = .clear
    }
    
    private func setLayout() {
        view.addSubviews(dimmedView, bottomSheetView)
        
        dimmedView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        if bottomSheetView.viewType == .login {
            bottomSheetView.snp.makeConstraints {
                $0.height.equalTo(defaultLoginHeight)
                $0.leading.trailing.bottom.equalToSuperview()
            }
        } else {
            bottomSheetView.snp.makeConstraints {
                $0.height.equalTo(defaultSignUpHeight)
                $0.leading.trailing.bottom.equalToSuperview()
            }
        }
    }
}

// MARK: - Apple Login

extension BottomSheetViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window!
    }
    
    // 사용자 인증 후 처리
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
              // Apple ID
          case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let _ = appleIDCredential.user
            let idToken = appleIDCredential.identityToken!
            guard let appleTokenString = String(data: idToken, encoding: .utf8) else { return }
            
            self.appleAccessToken = appleTokenString
              
          default:
              break
          }
    }
    
    // 사용자 인증 실패했을 때
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
      // Handle error.
    }
}

// MARK: - Network

extension BottomSheetViewController {
    private func loginAPI(socialParam: String) {
        SmeemLoadingView.showLoading()
        
        AuthAPI.shared.loginAPI(param: LoginRequest(social: socialParam,
                                                    fcmToken: UserDefaultsManager.fcmToken)) { response in
            
            switch response {
            case .success(let response):
                UserDefaultsManager.clientAccessToken = response.accessToken
                UserDefaultsManager.clientRefreshToken = response.refreshToken
                
                switch self.authType {
                case .login:
                    if response.hasPlan == false {
                        self.presentOnboardingPlanVC()
                    } else if response.hasPlan == true && response.isRegistered == false {
                        self.presentOnboardingAcceptVC()
                    } else {
                        // 삭제했다가 로그인한 유저
                        UserDefaultsManager.accessToken = response.accessToken
                        UserDefaultsManager.refreshToken = response.refreshToken
                        
                        self.presentHomeVC()
                    }
                case .signup:
                    if response.hasPlan == false || (response.hasPlan == true && response.isRegistered == false) {
                        AmplitudeManager.shared.track(event: AmplitudeConstant.Onboarding.signup_success.event)
                        guard let userPlanRequest = self.userPlanRequest else { return }
                        self.userPlanPatchAPI(userPlan: userPlanRequest, accessToken: response.accessToken)
                    } else {
                        // 계정이 있는 유저
                        UserDefaultsManager.accessToken = response.accessToken
                        UserDefaultsManager.refreshToken = response.refreshToken
                        
                        self.presentHomeVC()
                    }
                }
            case .failure(let error):
                self.showToast(toastType: .smeemErrorToast(message: error))
            }
            SmeemLoadingView.hideLoading()
        }
    }
    
    private func userPlanPatchAPI(userPlan: UserPlanRequest, accessToken: String) {
        SmeemLoadingView.showLoading()
        
        OnboardingAPI.shared.userPlanPathAPI(param: userPlan, accessToken: accessToken) { response in
            switch response {
            case .success(_):
                UserDefaultsManager.clientAccessToken = accessToken
                
                let userNicknameVC = UserNicknameViewController()
                self.navigationController?.pushViewController(userNicknameVC, animated: true)
            case .failure(let error):
                self.showToast(toastType: .smeemErrorToast(message: error))
            }
            
            SmeemLoadingView.hideLoading()
        }
    }
}
