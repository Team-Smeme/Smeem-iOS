//
//  SurveryView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 3/8/25.
//

import SwiftUI

struct SurveryModel {
    let diaryResponse: PostDiaryResponse
    let userName: String
    let coachingCount: Int
}

struct SurveryView: View {
    
    
    var survey: SurveryModel
    
    @State private var selectedOption: Int? = nil
    @State private var isSelected: Bool = false
    @State private var surveryText: String = ""

    
    let items: [(image: String, text: String)] = [
        ("iconThumbUpMono", "좋아요"),
        ("iconThumbDownMono", "싫어요")
    ]
    
    let surveyArray = [
        "이해하기 어려움", "너무 짧음", "피드백 오류", "단어 피드백 부족", "문법 피드백 부족"
    ]
    private let surveyDic: [Int:String] = [0: "HARD_TO_UNDERSTAND",
                                           1: "TOO_SHORT",
                                           2: "FEEDBACK_ERROR",
                                           3: "WORD_FEEDBACK_LACK",
                                           4: "GRAMMAR_FEEDBACK_LACK"]
    
    @State private var selectedItems: Set<Int> = [] // 선택된 버튼 저장
    
    let columns = [
        GridItem(.flexible(minimum: 50), spacing: 8), // 가변 크기 버튼
        GridItem(.flexible(minimum: 50), spacing: 8)  // 2줄 배치
    ]
    
    var body: some View {
        
        ZStack {
            Color.clear // 투명한 배경 추가
                    .contentShape(Rectangle()) // 터치 이벤트를 감지하도록 설정
                    .onTapGesture {
                        hideKeyboard()
                    }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        let homeVC = HomeTabBarController()
                        // 토스트 아무값
                        homeVC.homeVC.handlePostDiaryAPI(with: survey.diaryResponse, toastType: .changed)
                        changeRootViewController(homeVC)
                    } label: {
                        Text("닫기")
                            .font(Font.custom("Pretendard", size: 16)).fontWeight(.medium)
                            .foregroundColor(Color(.gray300))
                    }
                    .padding(EdgeInsets(top: 23, leading: 0, bottom: 23, trailing: 16))
                }
                
                VStack(alignment: .center, spacing: 16) {
                    Text("\(survey.userName)님,\n오늘까지 코칭을 \(survey.coachingCount)번 받으셨네요!\n꾸준함이 대단해요! 👏")
                        .font(Font.custom("Pretendard", size: 16)).fontWeight(.medium)
                        .foregroundColor(Color(UIColor.black))
                        .multilineTextAlignment(.center)
                    
                    Text("AI 코칭, 어떠셨나요?")
                        .font(Font.custom("Pretendard", size: 20)).fontWeight(.bold)
                        .foregroundColor(Color(UIColor.black))
                }
                
                HStack {
                    ForEach(items.indices, id: \.self) { index in
                        VStack(alignment: .center, spacing: 12) {
                            Image(items[index].image)
                                .renderingMode(.template)
                                .foregroundColor(getImageColor(for: index))
                                .frame(width: 120, height: 120)
                                .background(getBackgroundColor(for: index))
                                .cornerRadius(10)
                                .onTapGesture {
                                    if index != selectedOption {
                                        surveryText = ""
                                    }
                                    selectedOption = index
                                }
                            Text(items[index].text)
                                .font(Font.custom("Pretendard", size: 16)).fontWeight(.medium)
                                .foregroundColor(Color.black)
                        }
                    }
                }
                
                if selectedOption == nil {
                    // 아무것도 안 누른 상태의 코칭 버튼
                    
                } else if selectedOption == 0 {
                    // 좋아요 눌렀을 때
                    TextEditor(text: $surveryText)
                        .customStyleEditor(placeholder: "(선택) 이유를 적어주세요.",
                                           userInput: $surveryText)
                        .padding(18)
                } else {
                    // 싫어요 눌렀을 때
                    VStack(spacing: 8) { // 버튼 행 간격 8px
                        HStack(spacing: 8) { // 첫 번째 줄 (3개)
                            ForEach(0..<3, id: \.self) { index in
                                selectableButton(index: index)
                            }
                        }
                        HStack(spacing: 8) { // 두 번째 줄 (2개)
                            ForEach(3..<5, id: \.self) { index in
                                selectableButton(index: index)
                            }
                        }
                    }
                    .padding()
                    
                    TextEditor(text: $surveryText)
                        .customStyleEditor(placeholder: "(선택) 이유를 적어주세요.",
                                           userInput: $surveryText)
                        .padding(18)
                        .frame(minHeight: selectedOption == 0 ? 294 : 158)
                }
                
                Spacer()
                
                Button(action: {
                    // 서버 통신 필요함
                    Task {
                        do {
                            // surveyPostAPI 호출
                            let request: SurveyRequest!
                            let dissatisfactionTypes = selectedItems.map { surveyDic[$0] ?? "" }.filter{ !$0.isEmpty }
                            if selectedOption == 0 {
                                request = SurveyRequest(diaryId: survey.diaryResponse.diaryID, isSatisfied: true, dissatisfactionTypes: [], reason: surveryText)
                            } else {
                                request = SurveyRequest(diaryId: survey.diaryResponse.diaryID, isSatisfied: false, dissatisfactionTypes: dissatisfactionTypes, reason: surveryText)
                            }
                            
                            _ = try await SurveryService.shared.surveyPostAPI(request: request)
                            
                            let homeVC = HomeTabBarController()
                            homeVC.homeVC.handlePostDiaryAPI(with: survey.diaryResponse, toastType: .survey)
                            changeRootViewController(homeVC)
                            
                            print("Survey submitted successfully!")
                        } catch {
                            print("Failed to submit survey: \(error)")
                        }
                    }
                }, label: {
                    Text("의견 보내기")
                        .font(Font.custom("Pretendard", size: 18)).fontWeight(.bold)
                        .foregroundColor(Color(.white))
                })
                .disabled(selectedOption == nil ? true : false)
                .frame(width: screenWidth-36, height: 60, alignment: .center)
                .background(selectedOption == nil ? Color(UIColor.pointInactive) : Color(UIColor.point))
                .cornerRadius(5)
                .padding(.bottom, 16)
            }
            .keyboardAdaptive()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    private func toggleSelection(_ index: Int) {
        if selectedItems.contains(index) {
            selectedItems.remove(index)
        } else {
            selectedItems.insert(index)
        }
    }
    
    private func selectableButton(index: Int) -> some View {
        Button(action: {
            toggleSelection(index)
        }) {
            Text(surveyArray[index])
                .font(Font.custom("Pretendard", size: 14)).fontWeight(.regular)
                .padding(.horizontal, 15) // 가로 크기 자동 조정
                .frame(height: 44) // 높이 고정
                .foregroundColor(selectedItems.contains(index) ? Color(UIColor.point) : Color(UIColor.gray600))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(selectedItems.contains(index) ? Color(UIColor.point) : Color(UIColor.gray200), lineWidth: 1) // 빨간색 테두리
                )
        }
    }
    
    func getImageColor(for index: Int) -> Color {
        if selectedOption == nil {
            return Color(UIColor.pointInactive)
        } else if selectedOption == index {
            return Color(UIColor.point) // 선택된 버튼 (주황색)
        } else {
            return Color(UIColor.gray200) // 선택되지 않은 버튼 (흑백)
        }
    }

    func getBackgroundColor(for index: Int) -> Color {
        if selectedOption == nil {
            return Color(UIColor(red: 1, green: 0.863, blue: 0.831, alpha: 0.3))
        } else if selectedOption == index {
            return Color(UIColor.pointInactive)
        } else {
            return Color(UIColor.gray100)
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    SurveryView(survey: SurveryModel(diaryResponse: PostDiaryResponse(diaryID: 0, badges: [PopupBadge(name: "", imageUrl: "", type: "")]), userName: "짠미", coachingCount: 3))
}
