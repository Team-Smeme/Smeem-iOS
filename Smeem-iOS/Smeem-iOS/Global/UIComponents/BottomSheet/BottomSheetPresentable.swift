//
//  BottomSheetPresentable.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2024/04/30.
//

import UIKit

/**
 .medium() - halfScreen
 .large() - fullScreen
 */

protocol BottomSheetPresentable:UIViewController, UISheetPresentationControllerDelegate {
    func presentBottomSheet(viewController: UIViewController, customHeightMultiplier: CGFloat)
}

extension BottomSheetPresentable {
    func presentBottomSheet(viewController: UIViewController, customHeightMultiplier: CGFloat = 0.41) {
        viewController.view.backgroundColor = .white
        
        guard let sheet = viewController.sheetPresentationController else { return }

        if #available(iOS 16.0, *) {
            sheet.detents = [
                .custom { _ in
                    viewController.view.getDeviceHeight() * customHeightMultiplier }
            ]
        } else {
            sheet.detents = [.medium()]
        }
        
        sheet.delegate = self
        sheet.prefersGrabberVisible = false
        sheet.preferredCornerRadius = 30
        
        self.present(viewController, animated: true)
    }
}
