//
//  CoachingInteractor.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 11/18/24.
//

import Foundation
import Dependencies

final class CoachingStore: Store, ObservableObject {
    
    @Published var state: State
    
    init(diaryResponse: PostDiaryResponse) {
        self.state = State(diaryResponse: diaryResponse)
    }
    
    @Dependency(\.coachingService) var coachingService
    
    enum Action {
//        case toastMeesage
        case detailDiaryAPI(diaryID: Int)
//        case backButton
        case coachingButton(diaryID: Int)
    }
    
    struct State {
        var detailDiaryResponse = DetailDiaryResponse.empty
        var coachingResponse = CoachingsResponse.empty
        var toastMessage: SmeemError? = SmeemError.clientError
        var toastMessgaea: SmeemToast? = .completed
        
        var diaryResponse: PostDiaryResponse
        
        var hiddenIndex: Int = 0
    }
    
    @MainActor
    func send(action: Action) {
        switch action {
        case .detailDiaryAPI(let ID):
            Task {
                do {
                    state.detailDiaryResponse = try await coachingService.detailDiaryAPI(diaryID: ID)
                } catch _ {
//                    state.toastMessage = "일단 에러"
                }
            }
        case .coachingButton(let ID):
            Task {
                do {
                    state.hiddenIndex += 1
                    state.coachingResponse = CoachingsResponse.empty
                    state.hiddenIndex += 1
                } catch _ {
//                    state.toastMessage = "일단 에러"
                }
            }
        }
    }
}


