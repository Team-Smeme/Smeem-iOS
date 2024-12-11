//
//  View+.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2024/10/16.
//

import SwiftUI

extension View {
    var screenSize: CGRect {
        return UIScreen.main.bounds
    }
    
    var screenHeight: Double {
        return screenSize.height
    }
    
    var screenWidth: Double {
        return screenSize.width
    }
    
    func showEditConfirmation(
        title: String,
        message: String,
        firstActionTitle: String,
        secondActionTitle: String,
        firstActionHandler: (() -> Void)? = nil,
        secondActionHandler: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: firstActionTitle, style: .cancel) { _ in
            firstActionHandler?()
        })
        
        alert.addAction(UIAlertAction(title: secondActionTitle, style: .default) { _ in
            secondActionHandler?()
        })
        
        if let topViewController = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController {
            topViewController.present(alert, animated: true)
        }
    }
    
    func changeRootViewController(_ viewController: UIViewController) {
        guard let window = UIApplication.shared.windows.first else { return }
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            let rootVC = UINavigationController(rootViewController: viewController)
            window.rootViewController = rootVC
        })
    }
    
    func pushToUIKitView(_ viewController: UIViewController, dismissFullScreenCover: Bool = true) {
        // 현재 presenting된 view controller
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            
            // 현재 최상위 view controller (fullScreenCover 아래의 view controller)
            var topViewController = rootViewController
            while let presentedViewController = topViewController.presentedViewController {
                topViewController = presentedViewController
            }
            
            if let navigationController = topViewController as? UINavigationController {
                navigationController.pushViewController(viewController, animated: true)
                
                if dismissFullScreenCover,
                   let presentingView = topViewController.presentingViewController {
                    presentingView.dismiss(animated: false, completion: nil)
                }
            }
        }
    }
    
    func changeRootViewControllerAndPresent(_ viewControllerToPresent: UIViewController) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            
            let navigationController = UINavigationController(rootViewController: viewControllerToPresent)
            window.rootViewController = navigationController
            
            UIView.transition(with: window,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: nil)
            
            window.makeKeyAndVisible()
        }
    }
}
