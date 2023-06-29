//
//  ForeignDiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/05.
//

import UIKit

final class ForeignDiaryViewController: DiaryViewController {
    
    // MARK: - Property
    
    var keyboardHeight: CGFloat = 0.0
    var isKeyboardVisible: Bool = false

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        handleRightNavitationButton()
    }
    
    // MARK: - @objc
    
    override func leftNavigationButtonDidTap() {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    override func rightNavigationButtonDidTap() {
        if rightNavigationButton.titleLabel?.textColor == .point {
            postDiaryAPI()
            let HomeViewController = UINavigationController(rootViewController: HomeViewController())
            changeRootViewControllerAndPresent(HomeViewController)
        } else {
            showToast(toastType: .defaultToast(bodyType: .regEx))
            }
        }
    
    private func handleRightNavitationButton() {
        rightNavigationButton.addTarget(self, action: #selector(rightNavigationButtonDidTap), for: .touchUpInside)
    }
    
    override func keyboardWillShow(notification: NSNotification) {
        super.keyboardWillShow(notification: notification)
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        
        keyboardHeight = keyboardFrame.height
        isKeyboardVisible = true
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        super.keyboardWillHide(notification: notification)
        keyboardHeight = 0.0
        isKeyboardVisible = false
    }
    
    // MARK: - Custom Method
    
    private func showToast(toastType: ToastViewType) {
        regExToastView?.removeFromSuperview()
        regExToastView = SmeemToastView(type: toastType)
        
        let offset = convertByHeightRatio(107)
        regExToastView?.show(in: view, offset: CGFloat(offset), keyboardHeight: keyboardHeight)
        regExToastView?.hide(after: 1)
    }
}
