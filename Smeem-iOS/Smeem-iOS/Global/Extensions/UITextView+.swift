//
//  UITextView+.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/20.
//

import UIKit

extension UITextView {
    /**
     configureTypingAttributes - 새로 작성되는 text에 lineSpacing 적용
     configureAttributedText - 작성된 text에 lineSpacing 적용
     **/
    
    func getAttributes() -> [NSAttributedString.Key: Any] {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 2.5
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: style,
            .font: UIFont.b4
        ]
        
        return attributes
    }

    func configureTypingAttributes() {
        self.typingAttributes = getAttributes()
    }

    func configureAttributedText() {
        self.attributedText = NSAttributedString(string: self.text, attributes: getAttributes())
    }
    
    /**
     텍스트뷰 속성 지정해주는 메서드
     - topInset만 지정해서 사용
     ex) textView.createDiaryInputTextView(topInset: 20)
     */
    
    func configureDiaryTextView(topInset: CGFloat) {
        self.textContainerInset = .init(top: topInset, left: 18, bottom: 0, right: 18)
        self.font = .b4
        self.textColor = .smeemBlack
        self.tintColor = .point
    }
}
