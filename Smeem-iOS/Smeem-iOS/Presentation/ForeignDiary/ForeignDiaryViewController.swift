//
//  ForeignDiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/05.
//

import UIKit

final class ForeignDiaryViewController: DiaryViewController {
    
    var keyboardHeight: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        handleRightNavitationButton()
    }
    
    @objc override func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        
        keyboardHeight = keyboardFrame.height
    }
    
    @objc override func keyboardWillHide(notification: NSNotification) {
        keyboardHeight = 0.0
    }
    
    override func rightNavigationButtonDidTap() {
        if rightNavigationButton.titleLabel?.textColor == .point {
            //TODO: HomeView로 돌아가는 코드
            postDiaryAPI()
        } else {
            showToast(toastType: .defaultToast(bodyType: .regEx))
            }
        }
    
    private func handleRightNavitationButton() {
        rightNavigationButton.addTarget(self, action: #selector(rightNavigationButtonDidTap), for: .touchUpInside)
    }
    
    func showToast(toastType: ToastViewType) {
        regExToastView?.removeFromSuperview()

        regExToastView = SmeemToastView(type: toastType)
        regExToastView?.show(in: view, offset: 20, keyboardHeight: keyboardHeight)
        regExToastView?.hide(after: 1)
    }
}
