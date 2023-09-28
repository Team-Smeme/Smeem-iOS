//
//  SmeemTextView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/09/26.
//

import UIKit

protocol PlaceHolderTextView: AnyObject {
    var placeholderText: String? { get set }
    var placeholderColor: UIColor? { get set }
    func updatePlaceholder()
}

enum SmeemTextViewType {
    case display
    case editable(SmeemTextViewManager)
}

// MARK: - SmeemTextView

class SmeemTextView: UITextView, PlaceHolderTextView {
    
    // MARK: - Properties
    
    var placeholderText: String?
    var placeholderColor: UIColor?
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    convenience init(type: SmeemTextViewType,
                     placeholderColor color: UIColor = .gray300,
                     placeholderText placeholder: String?,
                     textViewManager manager: SmeemTextViewManager? = nil) {
        self.init(frame: .zero, textContainer: nil)
        
        self.placeholderColor = color
        self.placeholderText = placeholder ?? ""

        configureTextView(for: type)
        commonInit()
        updatePlaceholder()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Methods

extension SmeemTextView {
    
    // MARK: - Private Methods
    
    private func commonInit() {
        self.configureDiaryTextView(topInset: 20)
        self.configureTypingAttributes()
    }
    
    private func configureTextView(for type: SmeemTextViewType) {
        switch type {
        case .display:
            break
        case .editable(let manager):
            self.delegate = manager
            manager.textView = self
        }
    }
    
    // MARK: - Custom Methods
    
    func updatePlaceholder() {
        if text.isEmpty || text == placeholderText {
            text = placeholderText
            textColor = placeholderColor
            selectedTextRange = textRange(from: beginningOfDocument, to: beginningOfDocument)
        }
    }
}
