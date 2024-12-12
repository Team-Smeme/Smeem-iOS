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
            // MARK: 네비뷰
            VStack {
                if store.state.hiddenIndex != 1 {
                    HStack() {
                        Spacer()
                        Button(action: {
                            store.send(action: .amplitudeInput(type: .exitButtonTapped(store.state.isEnabled)))
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
                        if store.state.isEnabled {
                            store.send(action: .coachingButton(diaryID: store.state.diaryResponse.diaryID))
                            store.send(action: .amplitudeInput(type: .coachingButtonTapped(store.state.isEnabled)))
                        }
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
                    .disabled(!store.state.isEnabled)
                    .frame(width: screenWidth-32, height: 48, alignment: .center)
                    .background {
                        if store.state.isEnabled {
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
                        }
                    }
                    .background(store.state.isEnabled ? Color(UIColor.point) : Color(UIColor.gray400))
                    .cornerRadius(5)
                    
                    DiaryDetailView(diaryInformation: $store.state.detailDiaryResponse)
                    
                    Spacer()
                    
                    // MARK: 로티 화면
                } else if store.state.hiddenIndex == 1 {
                    VStack {
                        LottieView("smeemLoading")
                            .loopMode(.loop)
                            .frame(width: screenWidth, height: 164, alignment: .center)
                            .onAppear {
                                store.send(action: .amplitudeInput(type: .coachingLoading))
                             }
                        
                        Text("AI 코치가 내 일기를 분석하고 있어요\n잠시만 기다려주세요")
                            .font(Font.custom("Pretendard", size: 16))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                    }
                    
                    // MARK: 첨삭 화면
                } else {
                    CoachingCompleteView(coachingAppData: $store.state.coachingAppData)
                        .onAppear {
                            store.send(action: .amplitudeInput(type: .coachingResult))
                            store.send(action: .amplitudeInput(type: .coachingSwipe(1)))
                        }
                        .onChange(of: store.state.coachingAppData.currentIndex) { index in
                            store.send(action: .amplitudeInput(type: .coachingSwipe(index)))
                        }
                }
                
                // MARK: 첫 진입시 토스트뷰 실행
                SmemeToastView(type: $store.state.toastMessage)
                SmeemErrorToastView(type: $store.state.toastErrorMessage)
            }
            .overlay(alignment: .center) {
                // MARK: 최상단바에 로딩뷰
                if store.state.isLoadingView {
                    SmemeEmptyView()
                    SmemeLoadingView()
                }
            }
            .onAppear() {
                store.send(action: .detailDiaryAPI(diaryID: store.state.diaryResponse.diaryID))
            }
    }
}

#Preview {
    CoachingView(store: CoachingStore(service: CoachingService(), diaryResponse: PostDiaryResponse.empty))
}
