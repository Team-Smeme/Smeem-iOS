//
//  SmeemTextView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/09/26.
//

import UIKit

class SmeemTextView: UITextView {

    // MARK: - Properties

    var textViewManager: SmeemTextViewManager?
    
    var placeholderText: String = "" {
        didSet {
            if text.isEmpty {
                text = placeholderText
                textColor = placeholderColor
                selectedTextRange = textRange(from: beginningOfDocument, to: beginningOfDocument)
            }
        }
    }

    var placeholderColor: UIColor = .gray300

    // MARK: - Life Cycle

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        commonInit()
    }
    
    convenience init(placeholder: String?) {
        self.init(frame: .zero, textContainer: nil)
        self.placeholderText = placeholder ?? ""
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        delegate = self
        self.configureDiaryTextView(topInset: 20)
        self.configureTypingAttributes()
    }
}

extension SmeemTextView {
    func setPlaceholder(_ placeholderText: String) {
        self.placeholderText = placeholderText
        
        if text.isEmpty {
            text = placeholderText
            textColor = placeholderColor
            selectedTextRange = textRange(from: beginningOfDocument, to: beginningOfDocument)
        }
    }
}

// MARK: - UITextViewDelegate

extension SmeemTextView: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        let isTextEmpty = textView.text.isEmpty || textView.text == placeholderText

        if isTextEmpty {
            textView.text = placeholderText
            textView.textColor = placeholderColor
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        } else {
            textView.textColor = .smeemBlack
        }
    }

    func textViewDidChangeSelection(_ textView: UITextView) {
        if textView.textColor == placeholderColor {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        if updatedText.isEmpty {
            textView.text = placeholderText
            textView.textColor = placeholderColor
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            return false
        } else if textView.textColor == placeholderColor && !text.isEmpty {
            textView.text = nil
            textView.textColor = .smeemBlack
        }
        return true
    }
}

