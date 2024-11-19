//
//  CoachingTextView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2024/10/16.
//

import SwiftUI

struct CoachingTextView: View {
    @Binding var coachingText: String
    
    var body: some View {
        
        VStack(spacing: 16) {
            Text("일기를 잘 작성하셨어요! \n내용이 명확하고 흥미로웠습니다.\n이제 몇 가지 문법적 오류를 수정해 볼까요?")
              .font(Font.custom("Pretendard", size: 16))
            // Colors 상수 등록 필요
              .foregroundColor(Color(UIColor.smeemBlack))
              .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView {
                Text(coachingText)
                  .font(Font.custom("Pretendard", size: 16))
                  .foregroundColor(Color(UIColor.gray400))
                  .lineSpacing(0.375)
            }
            
            Spacer()
        }
        .padding(.horizontal, screenWidth * 0.048)
    }
}
//
//@available (iOS 17, *)
//#Preview {
//    CoachingTextView(coachingText: "")
//}
