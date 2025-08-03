//
//  SceneDelegate.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/03/21.
//

import UIKit

import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)
        
//        let rootViewController = UINavigationController(rootViewController: SplashViewController())
        self.window?.rootViewController = SplashViewController()
        self.window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        
        // MARK: Token Check
        // 앱에 처음 진입한 온보딩을 거치는 유저라면, 해당 API를 호출할 필요가 없다.
        if UserDefaultsManager.accessToken != "" {
            AuthService.shared.reLoginAPI() { result in
                switch result {
                case .success(let response):
                    if let accessToken = response.data?.accessToken {
                        UserDefaultsManager.accessToken = accessToken
                    }
                    if let refreshToken = response.data?.refreshToken {
                        UserDefaultsManager.refreshToken = refreshToken
                    }
                case .failure(let error):
                    // 1. 2주 후에 background 상태에서 진입한 유저일 경우
                    // 2. 서버쪽에서 무언가 오류가 났을 경우
                    // 401, 500 ...
                    // 유저 토큰 처리에 따라 분기할 수 있도록 Splash로 보낸다
                    print("error 발생", error)
//                    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//                       let delegate = scene.delegate as? SceneDelegate,
//                       let window = delegate.window {
//                        // 홈 화면으로 전환
//                        let homeViewController = SplashViewController() // 실제 홈 VC로 변경
//                        let navigationController = UINavigationController(rootViewController: homeViewController)
//                        window.rootViewController = navigationController
//                        window.makeKeyAndVisible()
//                    }
                }
            }
        }
        
        func sceneDidEnterBackground(_ scene: UIScene) {
            // Called as the scene transitions from the foreground to the background.
            // Use this method to save data, release shared resources, and store enough scene-specific state information
            // to restore the scene back to its current state.
        }
    }
}
