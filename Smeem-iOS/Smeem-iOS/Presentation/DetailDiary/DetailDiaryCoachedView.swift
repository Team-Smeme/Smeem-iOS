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
    var attributedText: AttributedString {
        var result = AttributedString("")
        
        for (index, sentence) in MockData.sentences.enumerated() {
            var attributedSentence = AttributedString(sentence.text)
            
            // 개별 문장 스타일 지정
            attributedSentence.foregroundColor = sentence.isCorrect ? UIColor.gray400 : UIColor.smeemWhite
            attributedSentence.backgroundColor = sentence.isCorrect ? nil : UIColor.point
            attributedSentence.font = .custom("Pretendard", size: 16)
            
            // 문장 추가
            result += attributedSentence
            
            // 마지막 문장이 아니면 공백 추가
            if index < MockData.sentences.count - 1 {
                result += AttributedString(" ")
            }
        }
        
        return result
    }
    
    var body: some View {
        SwiftUINavigationView()
        
        VStack(spacing: 16) {
            Text(MockData.headerText)
                .font(Font.custom("Pretendard", size: 16))
                .foregroundColor(Color(UIColor.smeemBlack))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView {
                Text(attributedText)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: screenHeight * 0.32)
            
            Spacer()
        }
        .padding(.horizontal, screenWidth * 0.048)
    }
}

extension DetailDiaryCoachedView {
    struct MockData {
        static let headerText = "일기를 잘 작성하셨어요! \n내용이 명확하고 흥미로웠습니다.\n이제 몇 가지 문법적 오류를 수정해 볼까요?"
        
        static let sentences: [SentenceData] = [
            SentenceData(text: "I watched Avatar with my boyfriend at Hongdae CGV.", isCorrect: true),
            SentenceData(text: "I should have skimmed the previous season what they were saying and the universe(??).", isCorrect: false),
            SentenceData(text: "What I was annoyed then was 두팔 didn't know that as me.", isCorrect: true),
            SentenceData(text: "I think 두팔 who is my boyfriend should study before wathcing….", isCorrect: true),
            SentenceData(text: "but Avatar2 is amazing movie I think.", isCorrect: true),
            SentenceData(text: "In my personal opinion", isCorrect: true)
        ]
    }
}

@available(iOS 17, *)
#Preview {
    DetailDiaryCoachedView()
}
