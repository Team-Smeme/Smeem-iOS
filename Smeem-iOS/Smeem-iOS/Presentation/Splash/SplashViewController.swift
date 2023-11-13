//
//  SplashViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/08/07.
//

import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Property
    
    private let splahManager: SplashManagerProtocol
    
    // MARK: - UI Property
    
    private let splashImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constant.Image.splashImage
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - Life Cycle

    init(splahManager: SplashManagerProtocol) {
        self.splahManager = splahManager
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
                
                Task {
                    do {
                        // 토큰 재발급 성공
                        let response = try await self.splahManager.relogin()
                        
                        UserDefaultsManager.accessToken = response.accessToken
                        UserDefaultsManager.refreshToken = response.refreshToken
                        
                        self.changeRootViewController(HomeViewController())
                    } catch {
                        // 토큰 재발급이 실패한 경우 (토큰 만료) - 로그아웃
                        self.presentSmeemStartVC()
                    }
                }
            } else {
                // 토큰이 없을 경우
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
