//
//  UILabel+.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/05/01.
//

import UIKit

extension UILabel {
    
    /// UILabel의 line height 적용 메서드
    func setTextWithLineHeight(lineHeight: CGFloat) {
        if let text = text {
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight
            
            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style,
                .baselineOffset: (lineHeight - font.lineHeight) / 4
            ]
            
            let attrString = NSAttributedString(string: text,
                                                attributes: attributes)
            self.attributedText = attrString
        }
    }
    
    /// UILabel의 line 수 길이 구하는 함수
    func countCurrentLines() -> CGFloat {
        let myText = text as? NSString

        let labelSize = myText?.boundingRect(with: CGSize(width: self.frame.width, height: .greatestFiniteMagnitude),
                                             options: .usesLineFragmentOrigin,
                                             attributes: [NSAttributedString.Key.font: font ?? UIFont()],
                                             context: nil)
        
        return ceil(CGFloat((labelSize?.height ?? 0) / font.lineHeight))
    }
    
    /**
     custom line height가 적용된 label height를 구하는 함수
     - Parameters:
          - lineHeight: 적용하려고하는 custom line
     - Returns: CGFloat형식의 현재 UILabel의 높이
     ~~~
     // lineHeight가 21일 때
     let currentHeight = label.calculateContentHeight(21)
     ~~~
     */
    
    func calculateContentHeight(lineHeight: CGFloat) -> CGFloat {
        let numberOfLines = self.countCurrentLines()
        
        return numberOfLines * lineHeight
    }
    
    func asColor(targetString: String, color: UIColor) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: targetString)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)
        attributedText = attributedString
    }
}
