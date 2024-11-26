//
//  DetailDiaryCoachedView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 11/21/24.
//

import SwiftUI

struct DetailDiaryCoachedView: View {
    
    @Binding var diaryText: String
    @Binding var coachingResponse: CoachingsResponse
    @State var currentIndex = 0
    @State private var selectedIndex = 0
    
    var body: some View {
        VStack(spacing: screenWidth * (16 / screenWidth)) {
            // 네비게이션 바
            SwiftUINavigationView(navigationbarType: .diaryDetails, selectedIndex: $selectedIndex)
            
            // 본문 내용
            ScrollView {
                Text(diaryText)
                    .modifier(HighlightModifier(
                        diaryText: diaryText,
                        corrections: coachingResponse.corrections,
                        highlightIndex: selectedIndex != 0 ? currentIndex : -1
                    ))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: screenHeight * (314 / screenHeight))
            .padding(.horizontal, screenWidth * (16 / screenWidth))
            .foregroundColor(Color(UIColor.gray400))
            
            HStack {
                Spacer()
                VStack(alignment: .trailing) {
                    Text("2023년 3월 27일 4:18PM")
                    HStack {
                        Text("유진이")
                    }
                }
                .font(Font(UIFont.c3))
                .foregroundColor(Color(UIColor.gray400))
            }
            .padding(.horizontal, screenWidth * (16 / screenWidth))
            
            // "코칭 ON"일 때만 표시
            if selectedIndex == 1 {
                VStack {
                    CoachingContentView(currentIndex: $currentIndex, coachingResponse: $coachingResponse)
                }
            } else {
                Spacer(minLength: screenHeight * (342 / screenHeight))
            }
        }
    }
}

@available(iOS 17, *)
#Preview {
    @State var diaryText = "I watched Avatar with my boyfriend at Hongdae CGV. I should have skimmed the previous season - Avatar1.. I really couldn’t get what they weere saying and the universe(??). What I was annoyed then was 두팔 didn’t know that as me. I think 두팔 who is my boyfriend should study before wathcing…. but Avatar2 is amazing movie I think. In my personal opinion, the jjin main character of Avatar2 is not Sully, but his son."
    
    @State var coachingResponse = CoachingsResponse.sample
    
    DetailDiaryCoachedView(diaryText: $diaryText, coachingResponse: $coachingResponse)
}
