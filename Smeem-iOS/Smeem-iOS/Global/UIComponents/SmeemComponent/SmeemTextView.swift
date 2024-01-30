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
    
    convenience init(type: SmeemTextViewType,
                     placeholderColor color: UIColor = .gray300,
                     placeholderText placeholder: String?,
                     textViewManager handler: SmeemTextViewHandler? = nil) {
        self.init(frame: .zero, textContainer: nil)
        
        configureTextView(for: type, color: color, text: placeholder ?? "")
        commonInit()
        updatePlaceholder()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        print("\(self) is being deinitialized")
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
