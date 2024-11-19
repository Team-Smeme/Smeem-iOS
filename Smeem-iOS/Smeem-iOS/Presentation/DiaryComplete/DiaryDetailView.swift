//
//  DiaryInformationView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 11/17/24.
//

import SwiftUI

struct DiaryDetailView: View {
    @Binding var diaryInformation: DetailDiaryResponse
    let fontHeight = UIFont(name: "Pretendard", size: 16)!.lineHeight
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Text(diaryInformation.content)
                    .font(Font.custom("Pretendard", size: 16))
                    .lineSpacing(24 - fontHeight)
                Spacer()
            }
            
            HStack {
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text(diaryInformation.createdAt)
                        .font(Font.custom("Pretendard", size: 14))
                        .foregroundStyle(Color(UIColor.gray500))
                        .multilineTextAlignment(.trailing)
                    
                    
                    Text(diaryInformation.username)
                        .font(Font.custom("Pretendard", size: 14))
                        .foregroundStyle(Color(UIColor.gray500))
                        .multilineTextAlignment(.trailing)
                }
            }
        }
        .padding(.top, 15)
        .padding(.leading, 18)
        .padding(.trailing, 18)
    }
}

//#Preview {
//    DiaryInformationView(diaryInformation: DetailDiaryResponse)
//}
