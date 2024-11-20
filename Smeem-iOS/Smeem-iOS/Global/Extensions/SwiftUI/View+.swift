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
    
    func changeRootViewController(_ viewController: UIViewController) {
        guard let window = UIApplication.shared.windows.first else { return }
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            let rootVC = UINavigationController(rootViewController: viewController)
            window.rootViewController = rootVC
        })
    }
}
