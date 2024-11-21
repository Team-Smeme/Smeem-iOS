//
//  DetailDiaryCoachedView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 11/21/24.
//

import SwiftUI

struct SentenceData: Identifiable {
    let id = UUID()
    let text: String
    let isCorrect: Bool
}

struct DetailDiaryCoachedView: View {
    
    @Binding var diaryText: String
    @Binding var coachingResponse: CoachingsResponse
    @State var currentIndex = 0
    @State private var selectedIndex = 0
    
    var attributedText: AttributedString {
        generateAttributedText(sentences: MockData.sentences)
    }
    
    var body: some View {
        VStack(spacing: screenWidth * (16 / screenWidth)) {
            // 네비게이션 바 포함
            SwiftUINavigationView(navigationbarType: .diaryDetails, selectedIndex: $selectedIndex)
            
            // 본문 내용
            ScrollView {
                Text(attributedText)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: screenHeight * (314 / screenHeight))
            .padding(.horizontal, screenWidth * (16 / screenWidth))
            
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
            if selectedIndex == 1 { // "코칭 ON"이 선택된 경우
                VStack(spacing: screenHeight * (20 / screenHeight)) {
                    Rectangle()
                        .frame(height: screenHeight * (8 / screenHeight))
                        .foregroundStyle(Color(UIColor.gray100))
                    
                    TabView(selection: $currentIndex) {
                        ForEach(coachingResponse.corrections.indices, id: \.self) { item in
                            ScrollView {
                                VStack(spacing: screenWidth * (8 / screenWidth)) {
                                    CoachingComparisonView(coachingResponse: $coachingResponse.corrections[item])
                                    
                                    CoachingExplanationView(coachingResponse: $coachingResponse.corrections[item])
                                }
                            }
                        }
                    }
                    .frame(width: screenWidth, height: screenHeight * (286 / screenHeight), alignment: .top)
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .padding(.horizontal, screenWidth * (16 / screenWidth))
                    
                    PageControl(currentPage: $currentIndex,
                                coachingResponse: $coachingResponse)
                }
            } else {
                Spacer(minLength: screenHeight * (342/screenHeight))
            }
        }
    }
}

extension DetailDiaryCoachedView {
    private func generateAttributedText(sentences: [SentenceData]) -> AttributedString {
        var result = AttributedString("")
        
        for (index, sentence) in sentences.enumerated() {
            var attributedSentence = AttributedString(sentence.text)
            
            // 개별 문장 스타일 지정
            attributedSentence.foregroundColor = sentence.isCorrect ? UIColor.gray400 : UIColor.smeemWhite
            attributedSentence.backgroundColor = sentence.isCorrect ? nil : UIColor.point
            attributedSentence.font = Font(UIFont.b4)
            
            // 문장 추가
            result += attributedSentence
            
            // 마지막 문장이 아니면 공백 추가
            if index < sentences.count - 1 {
                result += AttributedString(" ")
            }
        }
        
        return result
    }
    
    struct MockData {
        static let sentences: [SentenceData] = [
            SentenceData(text: "I watched Avatar with my boyfriend at Hongdae CGV.", isCorrect: true),
            SentenceData(text: "I should have skimmed the previous season what they were saying and the universe(??).", isCorrect: false),
            SentenceData(text: "What I was annoyed then was 두팔 didn't know that as me.", isCorrect: true),
            SentenceData(text: "I think 두팔 who is my boyfriend should study before watching….", isCorrect: true),
            SentenceData(text: "but Avatar2 is amazing movie I think.", isCorrect: true),
            SentenceData(text: "In my personal opinion", isCorrect: true)
        ]
    }
}

@available(iOS 17, *)
#Preview {
    @State var diaryText = "I watched Avatar with my boyfriend at Hongdae CGV. I should have skimmed the previous season   what they were saying and the universe(??). What I was annoyed then was 두팔 didn’t know that as me. I think 두팔 who is my boyfriend should study before wathcing…. but Avatar2 is amazing movie I think. In my personal opinion, the jjin main character "
    @State var coachingResponse = CoachingsResponse.empty
    
    DetailDiaryCoachedView(diaryText: $diaryText, coachingResponse: $coachingResponse)
}
