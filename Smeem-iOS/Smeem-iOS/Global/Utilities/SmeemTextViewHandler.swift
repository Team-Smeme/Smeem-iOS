//
//  SmeemTextViewManager.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/09/26.
//

import UIKit

protocol SmeemTextViewHandlerDelegate: AnyObject {
    func textViewDidChange(text: String, viewType: DiaryViewType)
}

// MARK: - SmeemTextViewManager

final class SmeemTextViewHandler: NSObject {
    
    // MARK: Properties
    
    static let shared = SmeemTextViewHandler()
    
    weak var diaryViewController: DiaryViewController?
    weak var textView: PlaceholderDisplayable?
    weak var delegate: SmeemTextViewHandlerDelegate?
    
    var viewType: DiaryViewType?
    
    // MARK: Methods
    
    func buttonColor(for isValid: Bool) -> UIColor {
        return isValid ? .point : .gray300
    }
}

// MARK: - Text Validation

extension SmeemTextViewHandler {
    func containsEnglishCharacters(with text: String) -> Bool {
        return text.getArrayAfterRegex(regex: "[a-zA-z]").count > 0
    }
    
    func containsKoreanCharacters(with text: String) -> Bool {
        return text.getArrayAfterRegex(regex: "[가-핳ㄱ-ㅎㅏ-ㅣ]").count > 0
    }
}

// MARK: - UITextViewDelegate

extension SmeemTextViewHandler: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let placeholderTextView = textView as? SmeemTextView  else { return }
        
        if textView.text.isEmpty || textView.text == placeholderTextView.placeholderText {
            placeholderTextView.updatePlaceholder()
        } else if !textView.text.isEmpty && textView.textColor == placeholderTextView.placeholderColor {
            textView.textColor = .smeemBlack
        }
        
        if let viewType = viewType {
            delegate?.textViewDidChange(text: textView.text, viewType: viewType)
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        guard let placeholderColor = self.textView?.placeholderColor else { return }
        
        if textView.textColor == placeholderColor {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let placeholderTextView = self.textView else { return true }
        
        let currentText = textView.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            textView.text = placeholderTextView.placeholderText
            textView.textColor = placeholderTextView.placeholderColor
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            return false
        } else if textView.textColor == placeholderTextView.placeholderColor && !text.isEmpty {
            textView.text = nil
            textView.textColor = .smeemBlack
        }
        return true
    }
}
