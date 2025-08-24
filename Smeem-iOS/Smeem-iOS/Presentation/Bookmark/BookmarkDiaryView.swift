//
//  BookmarkDiaryView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 8/23/25.
//

import SwiftUI

struct BookmarkDiaryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var diaryText: String = ""
    let service = PostDiaryAPI()
    
    // 외부에서 전달받는 표현
    let expression: String
    let translatedExpression: String
    
    var body: some View {
        VStack(spacing: 0) {
            // 상단 네비게이션 바
            HStack {
                Button("취소") {
                    dismiss()
                }
                .foregroundColor(.black)
                
                Spacer()
                
                Text("English")
                    .font(.headline)
                
                Spacer()
                
                Button("완료") {
                    PostDiaryAPI.shared.postDiary(param: PostDiaryRequest(content: self.diaryText, topicId: nil,
                                                              engKorExpression: expression + " " + translatedExpression)) { response in
                        switch response {
                        case .success(let response):
                            let homeVC = HomeTabBarController()
                            homeVC.homeVC.badgePopupData = response.badges
                            self.changeRootViewController(homeVC)
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
                .foregroundColor(diaryText.isEmpty ? .gray : .red) // 텍스트 없으면 회색, 있으면 빨강
                .disabled(diaryText.isEmpty) // 비활성화 처리
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(Color.white)
            
            Divider()
            
            // 제시된 표현
            VStack(alignment: .leading, spacing: 4) {
                Text(expression + " " + translatedExpression)
                    .font(.system(size: 16, weight: .semibold))
                
                TextEditor(text: $diaryText)
                            .overlay(alignment: .topLeading) {
                                if diaryText.isEmpty {
                                    Text("이 표현을 활용해 일기를 써보세요!")
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 4)   // TextEditor 기본 인셋에 맞춤
                                        .padding(.vertical, 8)
                                }
                            }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom) // 키보드 올라올 때 safe area 대응
        .navigationBarBackButtonHidden(true)
    }
}

//#Preview {
//    BookmarkDiaryView
//}
