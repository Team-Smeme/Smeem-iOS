//
//  DiaryCompleteView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 11/17/24.
//

import SwiftUI
import LottieUI

struct CoachingView: View {
    
    @StateObject var store: CoachingStore
    
    var body: some View {
        
        if store.state.hiddenIndex != 1 {
            HStack() {
                Spacer()
                
                Button(action: {
                    let homeVC = HomeViewController()
                    homeVC.handlePostDiaryAPI(with: store.state.diaryResponse)
                    changeRootViewController(homeVC)
                },
                       label: {
                    Text("닫기")
                        .tint(.black)
                })
                .padding(.trailing, 18)
            }
            .frame(height: 66)
        }
        
        // MARK: 일기 작성 완료 화면
        if store.state.hiddenIndex == 0 {
            Button(action: {
                store.send(action: .coachingButton(diaryID: store.state.diaryResponse.diaryID))
            }) {
                HStack {
                    Image("icnCrownMono")
                        .frame(width: 24, height: 24)
                    Text("하루 한 번 무료 AI 코칭")
                        .font(Font.custom("Pretendard", size: 16).weight(.bold))
                        .lineSpacing(0.19)
                        .foregroundColor(.white)
                }
            }
            .frame(width: screenWidth-32, height: 48, alignment: .center)
            .background(
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 1, green: 0, blue: 0.02).opacity(0.2), location: 0.00),
                        Gradient.Stop(color: .white.opacity(0.2), location: 0.28),
                        Gradient.Stop(color: .white.opacity(0.2), location: 0.83),
                        Gradient.Stop(color: Color(red: 1, green: 0, blue: 0.02).opacity(0.2), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0.15, y: -1.24),
                    endPoint: UnitPoint(x: 0.72, y: 3.4)
                )
            )
            .background(Color(UIColor.point))
            .cornerRadius(5)
            
            DiaryDetailView(diaryInformation: $store.state.detailDiaryResponse)
                .onAppear {
                    store.send(action: .detailDiaryAPI(diaryID: store.state.diaryResponse.diaryID))
                }
            
            Spacer()
            
        // MARK: 로티 화면
        } else if store.state.hiddenIndex == 1 {
            VStack {
                LottieView("smeemLoading")
                    .loopMode(.loop)
                    .frame(width: screenWidth, height: 164, alignment: .center)
                
                Text("AI 코치가 내 일기를 분석하고 있어요\n잠시만 기다려주세요")
                    .font(Font.custom("Pretendard", size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
            }
            
        // MARK: 첨삭 화면
        } else {
            CoachingCompleteView(diaryText: $store.state.detailDiaryResponse.content,
                                 coachingResponse: $store.state.coachingResponse)
        }
        
//        SmeemErrorToastView(type: $store.state.toastMessage)
        SmemeToastView(type: $store.state.toastMessgaea)
    }
}

//#Preview {
//    CoachingView(store: CoachingStore(diaryResponse: PostDiaryResponse.empty))
//}
