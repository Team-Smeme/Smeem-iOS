//
//  DetailDiaryCoachedView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 11/21/24.
//

import Combine
import SwiftUI
import UIKit

struct DetailDiaryCoachedView: View {
    
    // MARK: - Properties
    
    @StateObject private var navigationViewModel = NavigationViewModel()
    @State private var cancelBag = Set<AnyCancellable>()
    
    @State private var response: DetailDiaryResponse?
    @State private var isLoading = false
    @State private var onError = false
    @State private var error: SmeemError?
    
    @Binding var diaryID: Int?
    @State var diaryContent = ""
    @State var randomTopic = ""
    @State var currentIndex = 0
    @State private var filteredCorrections: [CoachingResponse] = []
    @State private var isShowingFloatingButtons = false
    @State private var selectedIndex = 0
    @State private var navigationbarType: NavigationbarType = .diaryDetails
    
    @State private var toastErrorMessage: SmeemError? = nil
    var toastMessage: SmeemToast? = .completed
    @Environment(\.dismiss) private var dismiss
    
    private let detailDiaryService = DetailDiaryService.shared
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            SwiftUINavigationView(navigationViewModel: navigationViewModel,
                                  selectedIndex: $selectedIndex,
                                  navigationbarType: navigationbarType
            )
            .onReceive(navigationViewModel.leftButtonTapped) {
                dismiss()
            }
            .onReceive(navigationViewModel.rightButtonTapped) {
                isShowingFloatingButtons = true
            }
            .confirmationDialog("", isPresented: $isShowingFloatingButtons) {
                Button("수정하기", role: .none) {
                    if navigationbarType == .diaryDetails {
                        showEditConfirmation(
                            title: "수정 확인",
                            message: "수정시 모든 코칭 내용이 사라집니다. 그래도 수정하시겠습니까?",
                            firstActionTitle: "취소",
                            secondActionTitle: "확인",
                            firstActionHandler: { },
                            secondActionHandler: {
                                navigateToEditDiary()
                            }
                        )
                    } else {
                        navigateToEditDiary()
                    }
                }
                
                Button("삭제하기", role: .destructive) {
                    deleteDiaryWithAPI(diaryID: diaryID ?? 0)
                }
                
                Button("취소", role: .cancel) {
                    isShowingFloatingButtons = false
                }
            }
            
            if let topic = response?.topic {
                if topic != "" {
                    RandomTopicViewSwiftUI(contentText: response?.topic)
                }
            }
            
            if let response = response {
                ScrollableDiaryView(
                    diaryText: response.content,
                    corrections: filteredCorrections,
                    currentIndex: currentIndex,
                    selectedIndex: selectedIndex,
                    dateText: response.createdAt,
                    authorText: response.username
                )
            } else {
                if isLoading {
                    SmemeEmptyView()
                    SmemeLoadingView()
                }
            }
            
            // "코칭 ON"일 때만 표시
            if selectedIndex == 1 {
                        Spacer()
                        CoachingContentView(
                            currentIndex: $currentIndex,
                            detailDiaryResponse: Binding(
                                get: { self.response ?? .empty },
                                set: { _ in }
                            ),
                            corrections: $filteredCorrections
                        )
                    } else {
                        Spacer()
                    }
        }
        .onAppear {
            Task {
                await fetchCoachingData(diaryID: diaryID ?? 0)
            }
        }
        .overlay {
            if isLoading {
                SmemeEmptyView()
                SmemeLoadingView()
            }
            
            if onError {
                ZStack {
                    Color.clear
                    VStack {
                        Spacer()
                        SmeemErrorToastView(type: $toastErrorMessage)
                            .padding(.bottom, 20.scaledByHeight())
                    }
                }
                .onDisappear {
                    onError = false
                }
            }
        }
    }
}

// MARK: - Extension

extension DetailDiaryCoachedView {
    func filterCorrection(_ response: DetailDiaryResponse) -> [CoachingResponse] {
        return response.corrections.filter { $0.isCorrected }.prefix(10).map{$0}
    }
    
    private func navigateToEditDiary() {
        let editVC = EditDiaryViewController()
        editVC.diaryID = self.diaryID ?? 0
        editVC.randomContent = self.randomTopic
        editVC.diaryTextView.text = self.diaryContent
        editVC.randomSubjectView.setData(contentText: self.randomTopic)
        self.pushToUIKitView(editVC)
    }
    
    @MainActor
    private func fetchCoachingData(diaryID: Int) async {
        isLoading = true
        do {
            let response = try await detailDiaryService.getDetailDiary(diaryID: diaryID)
            self.response = response
            self.diaryContent = response.content
            self.randomTopic = response.topic
            
            self.filteredCorrections = filterCorrection(response)
            
            if filteredCorrections.isEmpty {
                navigationbarType = .unCoached
            }
            
            isLoading = false
        } catch {
            isLoading = false
            self.error = error as? SmeemError
            self.onError = true
        }
    }
    
    func deleteDiaryWithAPI(diaryID: Int) {
        SmeemLoadingView.showLoading()
        
        detailDiaryService.deleteDiary(diaryID: diaryID) { result in
            
            switch result {
            case .success(_):
                let homeVC = HomeViewController()
                self.changeRootViewControllerAndPresent(homeVC)
            case .failure(let error):
                toastErrorMessage = error
                break
            }
            SmeemLoadingView.hideLoading()
        }
    }
}

@available(iOS 17, *)
#Preview {
    DetailDiaryCoachedView(diaryID: .constant(0))
}
