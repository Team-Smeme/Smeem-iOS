//
//  AuthController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/04/26.
//

import AuthenticationServices
import UIKit

import SnapKit

final class AuthViewController: UIViewController {
    
    private lazy var appleLoginButton: UIView = {
        let appleLoginButton = UIView()
        appleLoginButton.backgroundColor = .black
        return appleLoginButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupProviderLoginView()
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
