//
//  CoachingCompletedView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2024/10/16.
//

import SwiftUI

struct CoachingCompletedView: View {
    var body: some View {
        
        SwiftUINavigationView()
        
        VStack(spacing: 16) {
            Text(MockData.headerText)
              .font(Font.custom("Pretendard", size: 16))
            // Colors 상수 등록 필요
              .foregroundColor(Color(UIColor.smeemBlack))
              .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView {
                Text(MockData.diaryEntry)
                  .font(Font.custom("Pretendard", size: 16))
                  .foregroundColor(Color(UIColor.gray400))
                  .lineSpacing(0.375)
            }
            
            Spacer()
        }
        .padding(.horizontal, screenWidth * 0.048)
    }
}

extension CoachingCompletedView {
    struct MockData {
        static let headerText = "일기를 잘 작성하셨어요! \n내용이 명확하고 흥미로웠습니다.\n이제 몇 가지 문법적 오류를 수정해 볼까요?"
        static let diaryEntry = "I watched Avatar with my boyfriend at Hongdae CGV. I should have skimmed the previous season   what they were saying and the universe(??). What I was annoyed then was 두팔 didn’t know that as me. I think 두팔 who is my boyfriend should study before wathcing…. but Avatar2 is amazing movie I think. In my personal opinion, the jjin main character of Avatar2 is not Sully, but his son.the jjin main character of Avatar2 is not Sully, but his son.the jjin main character of Avatar2 is not Sully, but his son.the jjin main character of Avatar2 is not Sully, but his son.character of Avatar2 is not Sully, but his son.ly, but his ly, but his ly, but 여기부터 스크롤영역이라 내려가면 글자가 계속 나올거에욤ㄴㅇㄹ리ㅏㄴㅇ리ㅏㅓㄴ이ㅏ러민아ㅓ리ㅏㄴㅁ어리"
    }
}

@available (iOS 17, *)
#Preview {
    CoachingCompletedView()
}
