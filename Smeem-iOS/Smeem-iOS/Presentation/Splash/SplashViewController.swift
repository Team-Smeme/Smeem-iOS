//
//  SplashViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/08/07.
//

import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Property
    
    // MARK: - UI Property
    
    private let splashImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constant.Image.splashImage
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
        checkDidLogin()
    }
    
    // MARK: - @objc
    
    // MARK: - Custom Method
    
    private func checkDidLogin() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // access 토큰을 가지고 있음
            if UserDefaultsManager.accessToken != "" {
                AuthAPI.shared.reLoginAPI() { response in
                    // 토큰 재발급 성공 (refreshToken)
                    if response.success {
                        if let accessToken = response.data?.accessToken {
                            UserDefaultsManager.accessToken = accessToken
                        }
                        if let refresToken = response.data?.refreshToken {
                            UserDefaultsManager.refreshToken = refresToken
                        }
                        
                        self.changeRootViewController(HomeViewController())
                    }
                    // 토큰 만료(재로그인)
                    else {
                        self.presentSmeemStartVC()
                    }
                }
            } else {
                // 토큰을 가지고 있지 않음
                self.presentSmeemStartVC()
            }
        }
    }
    
    @objc func startButtonDidTap() {
        let onboardingVC = GoalViewController(viewtype: .onboarding)
        self.navigationController?.pushViewController(onboardingVC, animated: true)
    }
    
    // MARK: - Custom Method
    
    private func setBackgroundColor() {
        view.backgroundColor = .white
    }

    private func setLayout() {
        view.addSubview(splashImageView)
        
        splashImageView.snp.makeConstraints {
            $0.top.trailing.leading.bottom.equalToSuperview()
        }
    }
}

// MARK: - Network

extension SplashViewController {
    private func reloginAPI() {
        AuthAPI.shared.reLoginAPI() { response in
            guard let _ = response.data else { return }
        }
    }
}
