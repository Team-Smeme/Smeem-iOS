//
//  DiaryCompleteView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 11/17/24.
//

import SwiftUI
import ComposableArchitecture

struct CoachingView: View {
    
    let store: StoreOf<CoachingStore>
    
    var body: some View {
        WithViewStore(store, observe: {$0}) { viewStore in
            HStack() {
                Spacer()
                
                Button(action: {
                    let homeVC = HomeViewController()
                    homeVC.handlePostDiaryAPI(with: viewStore.state.postDiarayResponse)
                    changeRootViewController(homeVC)
                },
                       label: {
                    Text("닫기")
                        .tint(.black)
                })
                .padding(.trailing, 18)
            }
            .frame(height: 66)
            
            Button(action: {}) {
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
            
            DiaryDetailView(diaryInformation: viewStore.binding(
                get: { $0.detailDiaryResponse },
                send: { .setDetailDiary(response: $0)}
            )
        )
        .onAppear {
            viewStore.send(.getDetailDiary(diaryID: viewStore.state.postDiarayResponse.diaryID))
        }
            
            Spacer()
        }
    }
}

#Preview {
    CoachingView(store: Store(initialState: CoachingStore.State(postDiarayResponse: PostDiaryResponse.empty), reducer: { CoachingStore() }))
}
