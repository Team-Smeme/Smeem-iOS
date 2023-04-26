//
//  AuthController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/04/26.
//

import AuthenticationServices
import UIKit

import SnapKit
import KakaoSDKUser

final class AuthViewController: UIViewController {
    
    private lazy var appleLoginButton: UIView = {
        let appleLoginButton = UIView()
        appleLoginButton.backgroundColor = .black
        return appleLoginButton
    }()
    
    private lazy var kakaoLoginButton: UIButton = {
        let kakaoLoginButton = UIButton()
        kakaoLoginButton.backgroundColor = .blue
        kakaoLoginButton.addTarget(self, action: #selector(loginKakao), for: .touchUpInside)
        return kakaoLoginButton
    }()
    
    private lazy var outBUtton: UIButton = {
        let outBUtton = UIButton()
        outBUtton.backgroundColor = .blue
        outBUtton.addTarget(self, action: #selector(unlinkClicked), for: .touchUpInside)
        return outBUtton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupProviderLoginView()
        
        view.addSubview(kakaoLoginButton)
        
        kakaoLoginButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(100)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        view.addSubview(outBUtton)
        
        outBUtton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(200)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(30)
        }
    }
    
    // 로그인 버튼 추가
    func setupProviderLoginView() {
      let authorizationButton = ASAuthorizationAppleIDButton()
      authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
      view.addSubview(authorizationButton)
        
        authorizationButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}

// MARK: - Apple Login
extension AuthViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window!
    }
    
    // apple 승인 요청
    @objc func handleAuthorizationAppleIDButtonPress() {
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
        
      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }
    
    // 사용자 인증 후 처리
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
              // Apple ID
          case let appleIDCredential as ASAuthorizationAppleIDCredential:
              
              // 계정 정보 가져오기
              let userIdentifier = appleIDCredential.user
              let fullName = appleIDCredential.fullName
              let email = appleIDCredential.email
              let idToken = appleIDCredential.identityToken!
              let tokeStr = String(data: idToken, encoding: .utf8)
           
              print("User ID : \(userIdentifier)")
              print("User Email : \(email ?? "")")
              print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
              print("token : \(String(describing: tokeStr))")
              
          default:
              break
          }
    }
    
    // 사용자 인증 실패했을 때
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
      // Handle error.
    }
}

// MARK: - Kakao Login

extension AuthViewController {
    @objc func loginKakao() {
        print("loginKakao() called.")

        // 카카오톡 설치 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("loginWithKakaoAccount() success.")

                        //do something
                        print("🧡 \(oauthToken)")
                    }
                }
        }
        // 카카오톡 미설치
        else {
            print("카카오톡 미설치")
        }
    }
    
    @objc func unlinkClicked(_ sender: Any) {
        // 연결 끊기 : 연결이 끊어지면 기존의 토큰은 더 이상 사용할 수 없으므로, 연결 끊기 API 요청 성공 시 로그아웃 처리가 함께 이뤄져 토큰이 삭제됩니다.
        UserApi.shared.unlink {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("unlink() success.")

                // 연결끊기 시 메인으로 보냄
            }
        }
    }
}
