//
//  AppDelegate.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/03/21.
//

import AuthenticationServices
import UIKit
import UserNotifications

import Firebase
import FirebaseCore
import FirebaseMessaging
import KakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        KakaoSDK.initSDK(appKey: ConfigConstant.nativeAppKey)
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: "") { (credentialState, error) in
            switch credentialState {
            case .authorized:
                // The Apple ID credential is valid.
                print("해당 ID는 연동되어있습니다.")
            case .revoked:
                // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                print("해당 ID는 연동되어있지않습니다.")
            case .notFound:
                // The Apple ID credential is either was not found, so show the sign-in UI.
                print("해당 ID를 찾을 수 없습니다.")
            default:
                break
            }
        }
        
        //앱 실행 중 강제로 연결 취소 시
        NotificationCenter.default.addObserver(forName: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil, queue: nil) { (Notification) in
            print("Revoked Notification")
            // 로그인 페이지로 이동
        }
        
        #if DEBUG
        let filePath = Bundle.main.path(forResource: "GoogleService-Info-Dev", ofType: "plist")!
        #else
        let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!
        #endif
        let options: FirebaseOptions? = FirebaseOptions.init(contentsOfFile: filePath)
        
        FirebaseApp.configure(options: options!)
        
        // 메시지 대리자 설정
        Messaging.messaging().delegate = self
        
        // userNotificationCenter 생성
        UNUserNotificationCenter.current().delegate = self
        
        // APNs 등록
        application.registerForRemoteNotifications()
        
        return true
    }
    
    // deviceToken을 할당하여 Firebase Messaging 서버에 토큰 등록
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // foreground (앱 켜진 상태)에서 알림 오는 설정 (알림 안 오게 빈 배열 전송)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([])
    }
    
    // 푸시 알림 클릭시 홈에서 시작하도록
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // 푸시 알림 클릭시
        if let _ = userInfo["aps"] as? Dictionary<String, Any> {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let window = windowScene.windows.first  else { return }
            let rootViewController = UINavigationController(rootViewController: SplashViewController())
            
            window.rootViewController = rootViewController
            window.makeKeyAndVisible()
        }
    }
}

// MARK: - MessagingDelegate

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // 등록된 토큰 가져오기
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
              UserDefaultsManager.fcmToken = token
          }
        }
    }
}

