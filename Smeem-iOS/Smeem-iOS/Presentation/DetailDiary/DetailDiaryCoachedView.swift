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
    
    @StateObject private var navigationViewModel = NavigationViewModel()
    @State private var cancelBag = Set<AnyCancellable>()
    
    @State private var coachingsResponse = CoachingsResponse(corrections: [])
    @State private var response: DetailDiaryResponse?
    @State private var isLoading = false
    @State private var error: SmeemError?
    
    @Binding var diaryID: Int?
    @State var diaryContent = ""
    @State var randomTopic = ""
    @State var currentIndex = 0
    @State private var isShowingFloatingButtons = false
    @State private var selectedIndex = 0
    @State private var navigationbarType: NavigationbarType = .diaryDetails
    
    @Environment(\.dismiss) private var dismiss
    
    private let detailDiaryService = DetailDiaryService.shared
    
    var body: some View {
        VStack(spacing: 16.scaledByWidth()) {
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
                        showEditConfirmation()
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
            
            if let response = response {
                ScrollableDiaryView(
                    diaryText: response.content,
                    corrections: response.corrections,
                    currentIndex: currentIndex,
                    selectedIndex: selectedIndex,
                    dateText: response.createdAt,
                    authorText: response.username
                )
            } else {
                if isLoading {
                    ProgressView("Loading...")
                } else if let error = error {
                    Text("Error: \(error.localizedDescription)")
                }
            }
            
            // "코칭 ON"일 때만 표시
            if selectedIndex == 1 {
                Spacer()
                CoachingContentView(
                    currentIndex: $currentIndex,
                    coachingsResponse: $coachingsResponse,
                    coachingResponse: $coachingsResponse.corrections
                )
            } else {
                Spacer(minLength: 342.scaledByHeight())
            }
        }
        .onAppear {
            Task {
                await fetchCoachingData(diaryID: diaryID ?? 0)
            }
        }
    }
    
    private func showEditConfirmation() {
        let alert = UIAlertController(
            title: "수정 확인",
            message: "수정시 모든 코칭 내용이 사라집니다. 그래도 수정하시겠습니까?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            navigateToEditDiary()
        })
        
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
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
            
            let corrections = response.corrections ?? []
            self.coachingsResponse = CoachingsResponse(corrections: corrections)
            
            if corrections.isEmpty {
                navigationbarType = .unCoached
            }
            
            isLoading = false
        } catch {
            isLoading = false
            self.error = error as? SmeemError
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
                //Toast message
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
