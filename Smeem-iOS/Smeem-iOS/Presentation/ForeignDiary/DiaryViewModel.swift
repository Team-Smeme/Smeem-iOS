//
//  DiaryViewModel.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/11/02.
//

import Foundation

struct KeyboardInfo {
    var isKeyboardVisible: Bool = false
    var keyboardHeight: CGFloat = 0.0
}

// MARK: - DiaryViewModel

class DiaryViewModel {
    
    var randomTopicEnabled: Bool = false {
        didSet {
            onUpdateRandomTopic?(randomTopicEnabled)
        }
    }
    
    var isTextValid: Bool = false {
        didSet {
            onUpdateTextValidation?(isTextValid)
        }
    }
    
    var onUpdateRandomTopic: ((Bool) -> Void)?
    var onUpdateTextValidation: ((Bool) -> Void)?
    
    var topicID: Int? = nil
    var topicContent: String?
    var diaryID: Int?
    var badgePopupContent: [PopupBadge]?
    var isTopicCalled: Bool = false
    var rightButtonFlag = false
    var isInitialInput = true
    var keyboardInfo: KeyboardInfo?
}

// MARK: - Extensions

extension DiaryViewModel {
    func toggleRandomTopic() {
        randomTopicEnabled = !randomTopicEnabled
    }
    
    func updateTextValidation(_ isValid: Bool) {
        isTextValid = isValid
    }
}
