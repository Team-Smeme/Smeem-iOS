//
//  HighlightModifier.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 11/26/24.
//

import SwiftUI

/*
# 사용법
   - `diaryText`: 강조 표시를 적용할 전체 텍스트 (String)
   - `corrections`: 강조할 문장의 목록 (CoachingResponse 배열)
   - `highlightIndex`: 강조할 문장의 인덱스 (Int)
    
 `Text` 뷰에 `.modifier(HighlightModifier(...))`로 적용

# 예제 코드

Text(diaryText)
    .modifier(HighlightModifier(
        diaryText: diaryText,
        corrections: coachingResponse.corrections,
        highlightIndex: currentIndex
    ))
*/

struct HighlightModifier: ViewModifier {
    let diaryText: String
    let corrections: [CoachingResponse]
    let highlightIndex: Int

    func body(content: Content) -> some View {
        var attributedText = AttributedString(diaryText)
        
        for (index, correction) in corrections.enumerated() {
            if index == highlightIndex, let range = attributedText.range(of: correction.original_sentence) {
                attributedText[range].backgroundColor = Color(UIColor.point)
                attributedText[range].foregroundColor = Color(UIColor.smeemWhite)
            }
        }
        
        return Text(attributedText)
    }
}
