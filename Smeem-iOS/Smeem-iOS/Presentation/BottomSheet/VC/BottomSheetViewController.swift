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

final class BottomSheetViewController: UIViewController, LoginDelegate {
    
    private var hasPlan = false
    private var isRegistered = false
    private var badges: [badges] = []
    
    private var kakaoAccessToken: String? {
        didSet {
            guard let kakaoAccessToken = self.kakaoAccessToken else {
                print("⭐️⭐️⭐️ 언래핑 실패했을 경우 ⭐️⭐️⭐️")
                return
            }
            
            UserDefaultsManager.socialToken = kakaoAccessToken
            self.loginAPI(socialParam: "KAKAO")
        }
    }
    
    private var appleAccessToken: String? {
        didSet {
            guard let appleAccessToken = self.appleAccessToken else {
                print("⭐️⭐️⭐️ 언래핑 실패했을 경우 ⭐️⭐️⭐️")
                return
            }
            
            UserDefaultsManager.socialToken = appleAccessToken
            self.loginAPI(socialParam: "APPLE")
        }
    }

    // MARK: - Property
    
    var defaultLoginHeight: CGFloat = 282
    var defaultSignUpHeight: CGFloat = 394
    
    var popupBadgeData: [PopupBadge]?
    var userPlanRequest: UserPlanRequest?
    
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
    
    private func loginKakaoWithApp() {
        UserApi.shared.loginWithKakaoTalk { oAuthToken, error in
            if let error = error {
                print("⭐️⭐️⭐️ 에러 발생 ⭐️⭐️⭐️")
                return
            }
            
            print("Login with KAKAO App Success !!")
            
            self.kakaoAccessToken = oAuthToken?.accessToken
        }
    }
    
    private func loginKakaoWithWeb() {
        UserApi.shared.loginWithKakaoAccount { oAuthToken, error in
            if let error = error {
                print("⭐️⭐️⭐️ 에러 발생 ⭐️⭐️⭐️")
                return
            }
            
            print("Login with KAKAO App Success !!")
            
            self.kakaoAccessToken = oAuthToken?.accessToken
        }
    }
    
    func appleLoginDataSend() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
          
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
        AuthAPI.shared.loginAPI(param: LoginRequest(social: socialParam,
                                                    fcmToken: UserDefaultsManager.fcmToken)) { response in
            
            guard let data = response else { return }
            
            UserDefaultsManager.accessToken = data.accessToken
            UserDefaultsManager.refreshToken = data.refreshToken
            self.hasPlan = data.hasPlan
            self.isRegistered = data.isRegistered
            
            /// badge noti로 띄워 줄 준비
            self.badges = data.badges
        }
    }
}
