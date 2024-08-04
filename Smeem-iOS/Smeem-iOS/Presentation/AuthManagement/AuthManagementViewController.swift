//
//  AuthManagementViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/08/19.
//

import UIKit
import AuthenticationServices

import KakaoSDKUser

final class AuthManagementViewController: UIViewController {
    
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
        label.setTextWithLineHeight(lineHeight: 21)
        return label
    }()
    
    private lazy var infomationButton: UILabel = {
        let label = UILabel()
        label.text = "이용 안내"
        label.font = .b4
        label.textColor = .gray600
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(infomationButtonDidTap))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
        return label
    }()
    
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
        label.setTextWithLineHeight(lineHeight: 21)
        return label
    }()
    
    private lazy var logoutButton: UILabel = {
        let label = UILabel()
        label.text = "로그아웃"
        label.font = .b4
        label.textColor = .gray600
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(logoutButtonDidTap))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var resignButton: UILabel = {
        let label = UILabel()
        label.text = "계정 삭제"
        label.font = .b4
        label.textColor = .gray600
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resignButtonDidTap))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
        return label
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
        swipeRecognizer()
    }
    
    // MARK: - @objc
    
    @objc func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func logoutButtonDidTap() {
        let alert = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel) { _ in
            // 로그아웃 로직
        }
        let delete = UIAlertAction(title: "로그아웃", style: .destructive) { _ in
            self.logoutAPI()
        }
        alert.addAction(cancel)
        alert.addAction(delete)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func resignButtonDidTap() {
        let resignVC = ResignSummaryViewController()
        self.navigationController?.pushViewController(resignVC, animated: true)
    }
    
    @objc func infomationButtonDidTap() {
        if let url = URL(string: "https://smeem.notion.site/334e225bb69b45c28f31fe363ca9f25e?pvs=4") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @objc func responseToSwipeGesture() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func swipeRecognizer() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(responseToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    
    // MARK: - Custom Method
    
    private func kakaoResignAPI() {
        UserApi.shared.unlink { (error) in
            if let _ = error {
                self.showToast(toastType: .smeemErrorToast(message: .clientError, body: "카카오 에러입니다"))
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
            $0.height.width.equalTo(55)
        }
        
        infomationTitleLabel.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(24)
        }
        
        infomationButton.snp.makeConstraints {
            $0.top.equalTo(infomationTitleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(26)
            $0.height.equalTo(40)
            $0.width.equalTo(70)
        }
        
        grayLineOne.snp.makeConstraints {
            $0.top.equalTo(infomationButton.snp.bottom).offset(21)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(1)
        }
        
        authManagementTitlaLabel.snp.makeConstraints {
            $0.top.equalTo(grayLineOne.snp.bottom).offset(36)
            $0.leading.equalToSuperview().inset(24)
        }
        
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(authManagementTitlaLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(26)
            $0.height.equalTo(40)
            $0.width.equalTo(66)
        }
        
        resignButton.snp.makeConstraints {
            $0.top.equalTo(logoutButton.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(26)
            $0.height.equalTo(40)
            $0.width.equalTo(70)
        }
        
        grayLineTwo.snp.makeConstraints {
            $0.top.equalTo(resignButton.snp.bottom).offset(21)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(1)
        }
    }
}

extension AuthManagementViewController {
    private func resignAPI() {
//        SmeemLoadingView.showLoading()
//        
//        AuthService.shared.resignAPI() { result in
//            switch result {
//            case .success(_):
//                UserDefaultsManager.accessToken = ""
//                UserDefaultsManager.refreshToken = ""
//                UserDefaultsManager.clientAccessToken = ""
//                UserDefaultsManager.clientRefreshToken = ""
//                UserDefaultsManager.hasKakaoToken = nil
//                
//                self.changeRootViewController(SplashViewController())
//            case .failure(let error):
//                self.showToast(toastType: .smeemErrorToast(message: error))
//            }
//            
//            SmeemLoadingView.hideLoading()
//        }
    }
    
    private func logoutAPI() {
        SmeemLoadingView.showLoading()
        
        AuthService.shared.logoutAPI() { result in
            
            switch result {
            case .success(_):
                UserDefaultsManager.accessToken = ""
                UserDefaultsManager.clientAccessToken = ""
                UserDefaultsManager.clientRefreshToken = ""
                UserDefaultsManager.refreshToken = ""
                UserDefaultsManager.hasKakaoToken = nil
                
                self.changeRootViewController(SplashViewController())
            case .failure(let error):
                self.showToast(toastType: .smeemErrorToast(message: error))
            }
            
            SmeemLoadingView.hideLoading()
        }
    }
}
