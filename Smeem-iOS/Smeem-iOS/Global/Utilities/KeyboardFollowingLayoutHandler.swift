//
//  KeyboardFollowingLayoutHandler.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/10/01.
//

import UIKit

import SnapKit

class KeyboardLayoutAndScrollingHandler {
    private weak var bottomView: DiaryBottomView?
    private weak var targetTextView: SmeemTextView?
    
    init(targetView: SmeemTextView, bottomView: DiaryBottomView) {
        self.targetTextView = targetView
        self.bottomView = bottomView
        addKeyboardObservers()
    }
    
    deinit {
        removeKeyboardObservers()
    }
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        targetTextView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight - (bottomView?.frame.height ?? 0), right : 0)
        targetTextView?.scrollIndicatorInsets = targetTextView!.contentInset
        
        UIView.animate(withDuration : 0.3) { [weak self] in
            self?.bottomView?.transform = CGAffineTransform(translationX : 0,y : -keyboardHeight)
            self?.bottomView?.snp.updateConstraints { make in
                make.height.equalTo(53)
            }
        }
        
        adjustLayoutForKeyboard(notification: notification, keyboardVisible: true)
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        targetTextView?.contentInset = .zero
        targetTextView?.scrollIndicatorInsets = .zero
        
        UIView.animate(withDuration : 0.3) { [weak self] in
            self?.bottomView?.transform = CGAffineTransform.identity
            self?.bottomView?.snp.updateConstraints { make in
                make.height.equalTo(87)
            }
        }
        
        adjustLayoutForKeyboard(notification: notification, keyboardVisible: false)
    }
    
    private func adjustLayoutForKeyboard(notification: NSNotification, keyboardVisible: Bool) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        
        let keyboardHeight = keyboardFrame.height
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardVisible ? keyboardHeight : 0, right: 0)
        
        targetTextView?.contentInset = insets
        targetTextView?.scrollIndicatorInsets = insets
        
        if keyboardVisible {
            // 텍스트 뷰를 자동 스크롤하여 커서가 보이도록 처리
            if let cursorPosition = targetTextView?.selectedTextRange?.end {
                let caretPositionRect = targetTextView?.caretRect(for: cursorPosition)
                targetTextView?.scrollRectToVisible(caretPositionRect ?? .zero, animated: true)
            }
        }
    }
}
