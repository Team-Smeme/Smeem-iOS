//
//  ScrollableDiaryView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 11/26/24.
//

import SwiftUI

struct ScrollableDiaryView: View {
    let diaryText: String
    let corrections: [CoachingResponse]
    let currentIndex: Int
    let selectedIndex: Int
    let screenHeight: CGFloat
    let screenWidth: CGFloat
    let dateText: String
    let authorText: String
    
    var body: some View {
        VStack(spacing: 0) {
            // 일기 본문
            ScrollView {
                Text(diaryText)
                    .modifier(HighlightModifier(
                        diaryText: diaryText,
                        corrections: corrections,
                        highlightIndex: selectedIndex != 0 ? currentIndex : -1
                    ))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
            }
            .frame(height: screenHeight * (314 / screenHeight))
            
            // 작성 날짜, 작성자
            HStack {
                Spacer()
                VStack(alignment: .trailing) {
                    Text(dateText)
                    HStack {
                        Text(authorText)
                    }
                }
                .font(Font(UIFont.c3))
            }
        }
        .foregroundColor(Color(UIColor.gray400))
        .padding(.horizontal, screenWidth * (16 / screenWidth))
    }
}
