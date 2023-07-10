//
//  ForeignDiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/05.
//

import UIKit

final class ForeignDiaryViewController: DiaryViewController {
    
    // MARK: - Property
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleRightNavitationButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        randomSubjectToolTip?.removeFromSuperview()
    }
    
    // MARK: - @objc
    
    override func leftNavigationButtonDidTap() {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    override func rightNavigationButtonDidTap() {
        if rightNavigationButton.titleLabel?.textColor == .point {
            showLodingView(loadingView: self.loadingView)
            postDiaryAPI()
        } else {
            showToastIfNeeded(toastType: .defaultToast(bodyType: .regEx))
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

    }
    
    override func keyboardWillHide(notification: NSNotification) {
        super.keyboardWillHide(notification: notification)
        keyboardHeight = 0.0
    }
}
