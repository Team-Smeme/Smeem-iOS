//
//  SmeemTextViewManager.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/09/26.
//

import UIKit

protocol SmeemTextViewHandlerDelegate: AnyObject {
    func textViewDidChange(text: String, viewType: DiaryViewType)
    func onUpdateInputText(_ text: String)
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
        
        if textView.text.isEmpty {
            placeholderTextView.updatePlaceholder()
        }
        
        if let viewType = viewType {
            delegate?.textViewDidChange(text: textView.text, viewType: viewType)
        }
        
        delegate?.onUpdateInputText(textView.text ?? "")
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        guard let placeholderColor = self.textView?.placeholderColor else { return }
        
        if textView.textColor == placeholderColor {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
    }
    
    // Text가 완전히 지워지는 시점 감지
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let placeholderTextView = self.textView else { return true }

        let currentText = textView.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // 텍스트가 완전히 지워졌을 때 placeholderText를 보여주는 로직
        if updatedText.isEmpty {
            textView.text = placeholderTextView.placeholderText
            textView.textColor = placeholderTextView.placeholderColor
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            textViewDidChange(textView)
            return false
        } else if textView.textColor == placeholderTextView.placeholderColor && !text.isEmpty {
            textView.text = nil
            textView.textColor = .smeemBlack
        }
        return true
    }
}
