//
//  DiaryLayoutConfigurations.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/10/04.
//

import UIKit

class StepTwoKoreanLayoutConfig {
    let hintTextView: UITextView
    let thickLine: UIView
    
    init() {
        self.hintTextView = StepTwoKoreanLayoutConfig.createHintTextView()
        self.thickLine = SeparationLine.createThickLine()
    }
}

extension StepTwoKoreanLayoutConfig {
    private static func createHintTextView() -> UITextView {
        let textView = UITextView()
        textView.font = .b4
        textView.textContainerInset = .init(top: 16, left: 18, bottom: 16, right: 38)
        textView.scrollIndicatorInsets = .init(top: 16, left: 0, bottom: 16, right: 18)
        textView.isEditable = false
        textView.text = "오늘은 OPR을 공개한 날이었다. 안 떨릴 줄 알았는데 겁나 떨렸당. 사실 카페가 추웠어서 추워서 떠는 건지 긴장 돼서 떠는 건지 구분이 잘 안 갔다. 근데 사실 나는 다리 떠는 것도 습관이라 다리를 떨어서 블라블라블라블라블라블라블라블ㄹ라블라블라블라블라블라블라블라블ㄹ라"
        textView.configureAttributedText()
        return textView
    }
    
    func getHintViewText() -> String {
        return hintTextView.text ?? ""
    }
}
