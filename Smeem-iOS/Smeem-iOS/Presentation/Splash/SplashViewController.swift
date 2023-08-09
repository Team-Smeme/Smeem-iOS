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
                // 첫 번째 온보딩을 거치지 않은 경우
                self.presentUserFlow()
            // 토큰을 가지고 있지 않음
            } else {
                self.changeRootViewController(SmeemStartViewController())
            }
        }
    }
    
    private func setLayout() {
        view.addSubview(splashImageView)
        
        splashImageView.snp.makeConstraints {
            $0.top.trailing.leading.bottom.equalToSuperview()
        }
    }
}
