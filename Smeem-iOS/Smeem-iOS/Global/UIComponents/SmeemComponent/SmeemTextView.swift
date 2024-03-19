//
//  SmeemTextView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/09/26.
//

import UIKit

enum SmeemTextViewType {
    case display
    case editable(SmeemTextViewHandler)
}

// MARK: - SmeemTextView

final class SmeemTextView: UITextView {
    
    // MARK: Properties
    
    var textViewHandler: SmeemTextViewHandler?
    var placeholderText: String?
    var placeholderColor: UIColor?
    
    // MARK: Life Cycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    convenience init(diaryType: DiaryViewType,
                     type: SmeemTextViewType,
                     placeholderColor color: UIColor = .gray300,
                     placeholderText placeholder: String?,
                     textViewManager handler: SmeemTextViewHandler? = nil) {
        self.init(frame: .zero, textContainer: nil)
        
        configureTextView(for: type, color: color, text: placeholder ?? "")
        setKeyboardType(diaryType: diaryType)
        commonInit()
        updatePlaceholder()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func getKeyboardLanguage() -> String? {
        return "ko-KR"
    }

    override var textInputMode: UITextInputMode? {
        if let language = getKeyboardLanguage() {
            for inputMode in UITextInputMode.activeInputModes {
                if inputMode.primaryLanguage! == language {
                    return inputMode
                }
            }
        }
        return super.textInputMode
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
}

// MARK: - Extensions

extension SmeemTextView {
    private func commonInit() {
        self.configureDiaryTextView(topInset: 20)
        self.configureTypingAttributes()
    }
    
    private func setKeyboardType(diaryType: DiaryViewType) {
        switch diaryType {
        case .foregin, .stepTwoKorean:
            self.keyboardType = .asciiCapable
        default: break
        }
    }
    
    private func configureTextView(for type: SmeemTextViewType, color: UIColor?, text: String?) {
        switch type {
        case .display:
            self.placeholderText = nil
            self.placeholderColor = nil
        case .editable(let manager):
            self.placeholderColor = color
            self.placeholderText = text

            self.delegate = manager
            self.textViewHandler = manager
            manager.placeholderDelegate = self
        }
    }
}

// MARK: - PlaceholderDisplayable

extension SmeemTextView: PlaceholderDelegate {
    func updatePlaceholder() {
        if text.isEmpty {
            text = placeholderText
            textColor = placeholderColor
            selectedTextRange = textRange(from: beginningOfDocument,
                                          to: beginningOfDocument)
        }
    }
}
