//
//  SmeemTextView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/09/26.
//

import UIKit

protocol PlaceholderDisplayable: AnyObject {
    var placeholderText: String? { get set }
    var placeholderColor: UIColor? { get set }
}

enum SmeemTextViewType {
    case display
    case editable(SmeemTextViewHandler)
}

// MARK: - SmeemTextView

final class SmeemTextView: UITextView {
    
    // MARK: Properties
    
    var handler: SmeemTextViewHandler?
    var placeholderText: String?
    var placeholderColor: UIColor?
    
    // MARK: Life Cycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    convenience init(type: SmeemTextViewType,
                     placeholderColor color: UIColor = .gray300,
                     placeholderText placeholder: String?,
                     textViewManager manager: SmeemTextViewHandler? = nil) {
        self.init(frame: .zero, textContainer: nil)
        
        configureTextView(for: type, color: color, text: placeholderText ?? "")
        commonInit()
        updatePlaceholder()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Extensions

extension SmeemTextView {
    private func commonInit() {
        self.configureDiaryTextView(topInset: 20)
        self.configureTypingAttributes()
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
            manager.textView = self
            self.handler = manager
        }
    }
}

// MARK: - PlaceholderDisplayable

extension SmeemTextView: PlaceholderDisplayable {
    func updatePlaceholder() {
        if text.isEmpty {
            text = placeholderText
            textColor = placeholderColor
            selectedTextRange = textRange(from: beginningOfDocument,
                                          to: beginningOfDocument)
        }
    }
}
