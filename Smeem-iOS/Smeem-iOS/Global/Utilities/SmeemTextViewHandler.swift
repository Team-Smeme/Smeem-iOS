//
//  SmeemTextViewHandler.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/09/26.
//

import UIKit
import Combine

protocol PlaceholderDelegate: AnyObject {
    var placeholderText: String? { get set }
    var placeholderColor: UIColor? { get set }
}

protocol SmeemTextViewHandlerDelegate: AnyObject {
    func textViewDidChange(text: String, viewType: DiaryViewType)
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
    private (set) var textDidChangeSubject = CurrentValueSubject<String?, Never>(nil)
    
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
        
        textDidChangeSubject.send(textView.text ?? "")
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        guard let placeholderColor = self.placeholderDelegate?.placeholderColor else { return }
        
        if textView.textColor == placeholderColor {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
    }
    
    // Text가 완전히 지워지는 시점 감지
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
        } else if textView.textColor == placeholderTextView.placeholderColor && !text.isEmpty {
            textView.text = nil
            textView.textColor = .smeemBlack
        }
        return true
    }
}
