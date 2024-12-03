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
    let dateText: String
    let authorText: String

    @State private var contentHeight: CGFloat = 0

    var body: some View {
        VStack(spacing: 0) {
            // 본문 내용
            ScrollView {
                VStack(alignment: .leading, spacing: screenWidth * 0.02) {
                    // 텍스트 내용
                    Text(diaryText)
                        .modifier(HighlightModifier(
                            diaryText: diaryText,
                            corrections: corrections,
                            highlightIndex: selectedIndex != 0 ? currentIndex : -1
                        ))
                        .padding(.horizontal, screenHeight * (18 / screenHeight))
                        .padding(.bottom, screenHeight * (16 / screenHeight))
                        .foregroundColor(Color(UIColor.gray400))
                        .background( // 콘텐츠 크기를 측정하기 위한 백그라운드
                            GeometryReader { geometry in
                                Color.clear
                                    .onAppear {
                                        contentHeight = geometry.size.height
                                    }
                            }
                        )

                    // Footer (작성 날짜, 작성자)
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing, spacing: screenWidth * (4 / screenWidth)) {
                            Text(dateText)
                            Text(authorText)
                        }
                        .font(Font(UIFont.c3))
                        .foregroundColor(Color(UIColor.gray400))
                    }
                    .padding(.horizontal, screenWidth * (18 / screenWidth))
                }
                .padding(.bottom, screenHeight * (16 / screenHeight))
            }
            .frame(maxHeight: contentHeight + screenHeight * (100 / screenHeight)) // 텍스트 높이에 따른 동적 변경
        }
    }
}

