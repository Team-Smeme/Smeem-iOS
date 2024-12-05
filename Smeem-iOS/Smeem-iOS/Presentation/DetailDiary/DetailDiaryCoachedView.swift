//
//  DetailDiaryCoachedView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 11/21/24.
//

import Combine
import SwiftUI

struct DetailDiaryCoachedView: View {
    
    @StateObject private var navigationViewModel = NavigationViewModel()
    @State private var cancelBag = Set<AnyCancellable>()
    
    @State private var coachingsResponse = CoachingsResponse(corrections: [])
    @State private var response: DetailDiaryResponse?
    @State private var isLoading = false
    @State private var error: SmeemError?
    
    @Binding var diaryID: Int?
    @State var currentIndex = 0
    @State private var isShowingFullScreen = false
    @State private var selectedIndex = 0
    @State private var navigationbarType: NavigationbarType = .diaryDetails
    
    @Environment(\.dismiss) private var dismiss
    
    private let detailDiaryService = DetailDiaryService.shared
    
    var body: some View {
        VStack(spacing: 16.scaledByWidth()) {
            SwiftUINavigationView(viewModel: navigationViewModel,
                                  selectedIndex: $selectedIndex,
                                  navigationbarType: navigationbarType
            )
            .fullScreenCover(isPresented: $isShowingFullScreen) {
                FloatingButtonsSwiftUIView()
            }
            .onReceive(navigationViewModel.leftButtonTapped) {
                dismiss()
            }
            .onReceive(navigationViewModel.rightButtonTapped) {
                isShowingFullScreen = true
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
    
    @MainActor
    private func fetchCoachingData(diaryID: Int) async {
        isLoading = true
        do {
            let response = try await detailDiaryService.getDetailDiary(diaryID: diaryID)
            self.response = response
            
            // CoachingsResponse로 변환
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
}

@available(iOS 17, *)
#Preview {
    DetailDiaryCoachedView(diaryID: .constant(0))
}
