//
//  CoachingCell.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 11/16/24.
//

import SwiftUI

struct CoachingCompleteView: View {
    
    @Binding var diaryText: String
    @Binding var coachingResponse: CoachingsResponse
    @State var currentIndex = 0
    
    var body: some View {
        
        VStack(spacing: 15) {
            VStack(spacing: 16) {
                Text("일기를 잘 작성하셨어요! \n내용이 명확하고 흥미로웠습니다.\n이제 몇 가지 문법적 오류를 수정해 볼까요?")
                    .font(Font.custom("Pretendard", size: 16))
                    .foregroundColor(Color(UIColor.smeemBlack))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ScrollView {
                    HStack {
                        Text(diaryText)
                            .font(Font.custom("Pretendard", size: 16))
                            .foregroundColor(Color(UIColor.gray400))
                            .lineSpacing(0.375)
                        
                        Spacer()
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, screenWidth * 0.048)
            
            VStack(spacing: 20) {
                Rectangle()
                    .frame(height: 8)
                    .foregroundStyle(Color(UIColor.gray100))
                TabView(selection: $currentIndex) {
                    ForEach(coachingResponse.corrections.indices, id: \.self) { item in
                        ScrollView {
                            VStack(spacing: 8) {
                                CoachingComparisonView(coachingResponse: $coachingResponse.corrections[item])
                                
                                CoachingExplanationView(coachingResponse: $coachingResponse.corrections[item])
                            }
                        }
                    }
                }
                .frame(width: screenWidth, height: screenHeight * (326/screenHeight), alignment: .top)
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                PageControl(currentPage: $currentIndex,
                            coachingResponse: $coachingResponse)
            }
        }
    }
}

struct PageControl: View {
    @Binding var currentPage: Int
    @Binding var coachingResponse: CoachingsResponse
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(coachingResponse.corrections.indices, id: \.self) { pagingIndex in
                let isCurrentPage = currentPage == pagingIndex
                
                Capsule()
                    .fill(isCurrentPage ? .black : .gray)
                    .frame(width: 8.0, height: 8.0)
            }
        }
        .animation(.linear, value: currentPage)
    }
}

#Preview {
    @State var diaryText = "I watched Avatar with my boyfriend at Hongdae CGV. I should have skimmed the previous season   what they were saying and the universe(??). What I was annoyed then was 두팔 didn’t know that as me. I think 두팔 who is my boyfriend should study before wathcing…. but Avatar2 is amazing movie I think. In my personal opinion, the jjin main character "
    @State var coachingResponse = CoachingsResponse.empty
    
    CoachingCompleteView(diaryText: $diaryText, coachingResponse: $coachingResponse)
}
