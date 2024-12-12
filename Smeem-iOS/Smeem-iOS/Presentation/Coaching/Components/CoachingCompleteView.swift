//
//  CoachingCell.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 11/16/24.
//

import SwiftUI

struct CoachingCompleteView: View {
    
    @Binding var coachingAppData: CoachingAppData
    
    var body: some View {
        
        VStack(spacing: 15) {
            VStack(spacing: 16) {
                ScrollView {
                    VStack(spacing: 16) {
                        HStack {
                            Text(coachingAppData.correctResultText)
                                .font(Font.custom("Pretendard", size: 16)).fontWeight(.regular)
                                .foregroundColor(Color(UIColor.black))
                                .lineSpacing(0.375)
                            Spacer()
                        }
                        
                        HStack {
                            Text(coachingAppData.diaryText)
                                .modifier(HighlightModifier(
                                    diaryText: coachingAppData.diaryText,
                                    corrections: coachingAppData.corrections,
                                    highlightIndex: coachingAppData.currentIndex
                                ))
                                .font(Font.custom("Pretendard", size: 16))
                                .foregroundColor(coachingAppData.corrections.isEmpty
                                                 ? Color(UIColor.black)
                                                 : Color(UIColor.gray400))
                                .lineSpacing(0.375)
                            
                            Spacer()
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, screenWidth * 0.048)
            
            // 코칭 일기가 있을 때만 보여짐.
            if !coachingAppData.corrections.isEmpty {
                VStack(spacing: 20) {
                    Rectangle()
                        .frame(height: 8)
                        .foregroundStyle(Color(UIColor.gray100))
                TabView(selection: $coachingAppData.currentIndex) {
                        ForEach(coachingAppData.corrections.indices, id: \.self) { item in
                            ScrollView {
                                VStack(spacing: 8) {
                                    CoachingComparisonView(coachingResponse: $coachingAppData.corrections[item])
                                    
                                    CoachingExplanationView(coachingResponse: $coachingAppData.corrections[item])
                                }
                            }
                        }
                    }
                    .frame(width: screenWidth, height: screenHeight * (326/screenHeight), alignment: .top)
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    
                    PageControl(currentPage: $coachingAppData.currentIndex,
                                coachingResponse: $coachingAppData.corrections)
                }
            }
        }
    }
}

struct PageControl: View {
    @Binding var currentPage: Int
    @Binding var coachingResponse: [CoachingResponse]
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(coachingResponse.indices, id: \.self) { pagingIndex in
                let isCurrentPage = currentPage == pagingIndex
                
                Capsule()
                    .fill(isCurrentPage ? .black : .gray)
                    .frame(width: 8.0, height: 8.0)
            }
        }
        .animation(.linear, value: currentPage)
    }
}

//#Preview {
//    @State var diaryText = "I watched Avatar with my boyfriend at Hongdae CGV. I should have skimmed the previous season   what they were saying and the universe(??). What I was annoyed then was 두팔 didn’t know that as me. I think 두팔 who is my boyfriend should study before wathcing…. but Avatar2 is amazing movie I think. In my personal opinion, the jjin main character "
//    @State var coachingResponse = CoachingAppData(diaryText: "",
//                                                  corrections: CoachingsResponse.sample.corrections,
//                                                  correctResultText: "테스트")
//    
//    CoachingCompleteView(coachingAppData: coachingResponse, currentIndex: 0)
//}
