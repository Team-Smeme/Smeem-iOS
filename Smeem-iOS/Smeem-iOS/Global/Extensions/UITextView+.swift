//
//  UITextView+.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/20.
//

import UIKit

extension UITextView {
    func setLineSpacing() {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 2.5
        let attributes = [
            NSAttributedString.Key.paragraphStyle: style,
            NSAttributedString.Key.font: UIFont.b4
        ]
        self.textAlignment = .left
        self.sizeToFit()
        self.attributedText = NSAttributedString(string: self.text, attributes: attributes)
    }
}
