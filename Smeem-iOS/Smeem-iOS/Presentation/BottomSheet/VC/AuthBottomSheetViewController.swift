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

final class AuthBottomSheetViewController: UIViewController, LoginDelegate {
    
    private let loginManager: LoginManagerProtocol
    var authProtocol: AuthDataSendProtocol?
    private var loginData: LoginResponse = .init(accessToken: "", refreshToken: "", isRegistered: false, hasPlan: false)
    
    private var hasPlan = false
    private var isRegistered = false
    private var badges: [Badges] = []
    
    private var kakaoAccessToken: String? {
        didSet {
            guard let _ = self.kakaoAccessToken else {
                print("⭐️⭐️⭐️ 언래핑 실패했을 경우 ⭐️⭐️⭐️")
                return
            }
            
            UserDefaultsManager.socialToken = self.kakaoAccessToken!
            UserDefaultsManager.hasKakaoToken = true
            self.login(socialParam: "KAKAO")
        }
    }
    
    private var appleAccessToken: String? {
        didSet {
            guard let _ = self.appleAccessToken else {
                print("⭐️⭐️⭐️ 언래핑 실패했을 경우 ⭐️⭐️⭐️")
                return
            }
            
            UserDefaultsManager.socialToken = self.appleAccessToken!
            UserDefaultsManager.hasKakaoToken = false
            self.login(socialParam: "APPLE")
        }
    }

    // MARK: - Property
    
    var defaultHeight: CGFloat = 282
    
    var popupBadgeData: [PopupBadge]?
    var userPlanRequest: UserTrainingInfoRequest?
    
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
    
    init(loginManager: LoginManagerProtocol) {
        self.loginManager = loginManager
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        bottomSheetView.snp.makeConstraints {
            $0.height.equalTo(defaultHeight)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - Apple Login

extension AuthBottomSheetViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
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

extension AuthBottomSheetViewController: ViewControllerServiceable {
    private func login(socialParam: String) {
        Task {
            do {
                self.loginData = try await loginManager.login(model: LoginRequest(social: socialParam,
                                                              fcmToken: UserDefaultsManager.fcmToken))
                
                self.showLoadingView()
                
                UserDefaultsManager.clientAccessToken = loginData.accessToken
                UserDefaultsManager.clientRefreshToken = loginData.accessToken
                
                switch self.authType {
                case .login:
                    if loginData.hasPlan == false {
                        self.presentOnboardingPlanVC()
                    } else if loginData.hasPlan == true && loginData.isRegistered == false {
                        self.presentOnboardingAcceptVC()
                    } else {
                        // 삭제했다가 로그인한 유저
                        UserDefaultsManager.accessToken = loginData.accessToken
                        UserDefaultsManager.refreshToken = loginData.refreshToken
                        
                        self.presentHomeVC()
                    }
                case .signup:
                    if loginData.hasPlan == false || (loginData.hasPlan == true && loginData.isRegistered == false) {
                        //                        guard let userPlanRequest = self.userPlanRequest else { return }
                        UserDefaultsManager.clientAccessToken = loginData.accessToken
                        self.hideLoadingView()
                        self.dismiss(animated: false, completion: {
                            self.authProtocol?.sendTrainingAlarm()
                        })
                    } else {
                        UserDefaultsManager.accessToken = loginData.accessToken
                        UserDefaultsManager.refreshToken = loginData.refreshToken
                            
                        self.presentHomeVC()
                    }
                }
            }
        }
    }
}