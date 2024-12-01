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
        VStack(spacing: 16.scaledByWidth()) {
            SwiftUINavigationView(navigationbarType: .diaryDetails,
                                  selectedIndex: $selectedIndex)
            
            ScrollableDiaryView(
                diaryText: diaryText,
                corrections: coachingResponse.corrections,
                currentIndex: currentIndex,
                selectedIndex: selectedIndex,
                dateText: "2023년 3월 27일 4:18PM",
                authorText: "유진이"
            )
            
            // "코칭 ON"일 때만 표시
            if selectedIndex == 1 {
                Spacer()
                CoachingContentView(currentIndex: $currentIndex,
                                    coachingResponse: $coachingResponse)
            } else {
                Spacer(minLength: 342.scaledByHeight())
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
