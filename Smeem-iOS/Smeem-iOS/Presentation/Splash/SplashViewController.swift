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
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        setLayout()
//        checkDidLogin()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setLayout()
        checkDidLogin()
    }
    
    // MARK: - @objc
    
    // MARK: - Custom Method
    
    private func checkDidLogin() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            /// check update
            Task {
                do {
                    let appStoreVersion = try await System().latestVersion()!.split(separator: ".").map{$0}
                    let currentProjectVersion = System.appVersion!.split(separator: ".").map{$0}

                    if appStoreVersion[0] < currentProjectVersion[0] {
                        self.presentUpdatePopup()
                    } else {
                        self.checkToken()
                    }
                } catch {
                    throw NetworkError.failProjVersion
                }
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
    
    private func checkToken() {
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
    
    private func presentUpdatePopup() {
        let updateAlert = UIAlertController(title: "업데이트 알림", message: "보다 나아진 스밈의 최신 버전을 준비했어요! 새로운 버전으로 업데이트 후 이용해주세요.", preferredStyle: UIAlertController.Style.alert)
        
        let update = UIAlertAction(title: "업데이트", style: UIAlertAction.Style.default) { (_) in
            System().openAppStore()
            
            /// 0.5 delay 준 버전
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

                let restartAlert = UIAlertController(title: "업데이트 완료", message: "앱을 재실행합니다.", preferredStyle: UIAlertController.Style.alert)
                let restart = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (_) in

                    UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        exit(0)
                    }
                }

                restartAlert.addAction(restart)
                self.present(restartAlert, animated: true)
            }
            
            /// 아닌 버전
//            let restartAlert = UIAlertController(title: "업데이트 완료", message: "앱을 재실행합니다.", preferredStyle: UIAlertController.Style.alert)
//            let restart = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (_) in
//
//                UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    exit(0)
//                }
//            }
//
//            restartAlert.addAction(restart)
//            self.present(restartAlert, animated: true)
        }
        
        updateAlert.addAction(update)
        self.present(updateAlert, animated: true)
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
