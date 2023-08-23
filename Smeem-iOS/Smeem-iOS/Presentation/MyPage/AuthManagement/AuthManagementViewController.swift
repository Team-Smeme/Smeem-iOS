//
//  AuthManagementViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/08/19.
//

import UIKit
import AuthenticationServices
import WebKit

import KakaoSDKUser

final class AuthManagementViewController: UIViewController, WKNavigationDelegate {
    
    // MARK: - Property
    
    // MARK: - UI Property
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnBack, for: .normal)
        button.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let infomationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "정보"
        label.font = .s2
        label.textColor = .smeemBlack
        return label
    }()
    
    private lazy var infomationButton: UIButton = {
        let button = UIButton()
        button.setTitle("이용 안내", for: .normal)
        button.titleLabel?.font = .b4
        button.setTitleColor(.gray600, for: .normal)
        button.addTarget(self, action: #selector(infomationButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private var webView = WKWebView()
    
    private let grayLineOne: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    private let authManagementTitlaLabel: UILabel = {
        let label = UILabel()
        label.text = "계정 관리"
        label.font = .s2
        label.textColor = .smeemBlack
        return label
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.titleLabel?.font = .b4
        button.setTitleColor(.gray600, for: .normal)
        button.addTarget(self, action: #selector(logoutButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var resignButton: UIButton = {
        let button = UIButton()
        button.setTitle("계정 삭제", for: .normal)
        button.titleLabel?.font = .b4
        button.setTitleColor(.gray600, for: .normal)
        button.addTarget(self, action: #selector(resignButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let grayLineTwo: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        setLayout()
    }
    
    // MARK: - @objc
    
    @objc func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func logoutButtonDidTap() {
        self.logoutAPI()
    }
    
    @objc func resignButtonDidTap() {
        let alert = UIAlertController(title: "계정을 삭제하시겠습니까?", message: "이전에 작성했던 일기는 모두 사라집니다.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel) { _ in
            // 로그아웃 로직
        }
        let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
            if UserDefaultsManager.hasKakaoToken! {
                self.kakaoResignAPI()
            } else {
                self.resignAPI()
            }
        }
        alert.addAction(cancel)
        alert.addAction(delete)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func infomationButtonDidTap() {
        if let url = URL(string: "https://smeem.notion.site/334e225bb69b45c28f31fe363ca9f25e?pvs=4") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    // MARK: - Custom Method
    
    private func kakaoResignAPI() {
        UserApi.shared.unlink { (error) in
            if let error = error {
                print(error)
            }
            else {
                print("unlink() success.")
                // 스밈 회원 탈퇴 API 호출
                self.resignAPI()
            }
        }
    }
    
    private func setBackgroundColor() {
        view.backgroundColor = .white
    }
    
    private func setLayout() {
        view.addSubviews(backButton, infomationTitleLabel, infomationButton, grayLineOne,
                         authManagementTitlaLabel, logoutButton, resignButton, grayLineTwo)
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(11)
            $0.leading.equalToSuperview().inset(10)
        }
        
        infomationTitleLabel.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(24)
        }
        
        infomationButton.snp.makeConstraints {
            $0.top.equalTo(infomationTitleLabel.snp.bottom).offset(22)
            $0.leading.equalToSuperview().inset(26)
        }
        
        grayLineOne.snp.makeConstraints {
            $0.top.equalTo(infomationButton.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(1)
        }
        
        authManagementTitlaLabel.snp.makeConstraints {
            $0.top.equalTo(grayLineOne.snp.bottom).offset(36)
            $0.leading.equalToSuperview().inset(24)
        }
        
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(authManagementTitlaLabel.snp.bottom).offset(22)
            $0.leading.equalToSuperview().inset(26)
        }
        
        resignButton.snp.makeConstraints {
            $0.top.equalTo(logoutButton.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(26)
        }
        
        grayLineTwo.snp.makeConstraints {
            $0.top.equalTo(resignButton.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(1)
        }
    }
}

extension AuthManagementViewController {
    private func resignAPI() {
        AuthAPI.shared.resignAPI() { response in
            guard let _ = response.data else { return }
            
            UserDefaultsManager.accessToken = ""
            UserDefaultsManager.refreshToken = ""
            UserDefaultsManager.clientAccessToken = ""
            UserDefaultsManager.clientRefreshToken = ""
            UserDefaultsManager.hasKakaoToken = nil
            
            self.changeRootViewController(SplashViewController())
        }
    }
    
    private func logoutAPI() {
        AuthAPI.shared.logoutAPI() { response in
            guard let _ = response.data else { return }
            
            UserDefaultsManager.accessToken = ""
            UserDefaultsManager.clientAccessToken = ""
            UserDefaultsManager.clientRefreshToken = ""
            UserDefaultsManager.refreshToken = ""
            UserDefaultsManager.hasKakaoToken = nil
            
            self.changeRootViewController(SplashViewController())
        }
    }
}
