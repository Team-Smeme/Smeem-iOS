//
//  SmeemTextViewHandler.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/09/26.
//

import UIKit

protocol PlaceholderDelegate: AnyObject {
    var placeholderText: String? { get set }
    var placeholderColor: UIColor? { get set }
}

protocol SmeemTextViewHandlerDelegate: AnyObject {
    func textViewDidChange(text: String, viewType: DiaryViewType)
    func onUpdateInputText(_ text: String)
}

protocol PlaceholderDisplayable: AnyObject {
    var placeholderText: String? { get set }
    var placeholderColor: UIColor? { get set }
}

// MARK: - SmeemTextViewManager

final class SmeemTextViewHandler: NSObject {
    
    // MARK: Properties
    
    weak var placeholderDelegate: PlaceholderDelegate?
    weak var textViewHandlerDelegate: SmeemTextViewHandlerDelegate?
    
    var viewType: DiaryViewType?
}

// MARK: - Extensions

extension SmeemTextViewHandler {
    func placeholderTextForViewType(for viewType: DiaryViewType) -> String {
        switch viewType {
        case .foregin, .stepTwoKorean, .edit:
            return "일기를 작성해주세요"
        case .stepOneKorean:
            return "완전한 문장으로 한국어 일기를 작성하면, 더욱 정확한 힌트를 받을 수 있어요."
        }
    }
    
    // MARK: - Text Validation
    
    func containsEnglishCharacters(with text: String) -> Bool {
        return text.getArrayAfterRegex(regex: "[a-zA-z]").count > 0
    }
    
    func containsKoreanCharacters(with text: String) -> Bool {
        return text.getArrayAfterRegex(regex: "[가-핳ㄱ-ㅎㅏ-ㅣ]").count > 0
    }
    
    // Placeholder가 표시되고 있는지
    func isDisplayingPlaceholder(in textView: UITextView) -> Bool {
        guard let placeholderColor = self.placeholderDelegate?.placeholderColor else { return false }
        return textView.textColor == placeholderColor
    }

    // 새로운 텍스트가 비어있지 않은지
    func isNewTextNotEmpty(_ text: String) -> Bool {
        return !text.isEmpty
    }

    // 새로운 텍스트가 placeholder 텍스트와 다른지
    func isNewTextDifferentFromPlaceholder(_ text: String) -> Bool {
        guard let placeholderText = self.placeholderDelegate?.placeholderText else { return true }
        return text != placeholderText
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
            textViewHandlerDelegate?.textViewDidChange(text: textView.text, viewType: viewType)
        }
        
        textViewHandlerDelegate?.onUpdateInputText(textView.text ?? "")
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        guard let placeholderColor = self.placeholderDelegate?.placeholderColor else { return }
        
        if textView.textColor == placeholderColor {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let placeholderTextView = self.placeholderDelegate else { return true }

        let currentText = textView.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // 텍스트가 완전히 지워졌을 때 placeholderText를 보여주는 로직
        if updatedText.isEmpty {
            textView.text = placeholderTextView.placeholderText
            textView.textColor = placeholderTextView.placeholderColor
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            textViewDidChange(textView)
            return false
        } else if isDisplayingPlaceholder(in: textView) && text == "" {
            // 백스페이스를 눌렀을 때
            // 이전에 입력한 텍스트가 플레이스홀더로 인식되지 않도록 처리
            textView.text = nil
            textView.textColor = .smeemBlack
            return false
        }
        
        // 추가된 부분: 한 음절만 입력해도 자동으로 추가되는 문제 해결
        if isDisplayingPlaceholder(in: textView) && isNewTextNotEmpty(text) && isNewTextDifferentFromPlaceholder(text) {
            textView.text = nil
            textView.textColor = .smeemBlack
        }

        return true
    }
}
