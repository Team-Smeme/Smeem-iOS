//
//  CoachingInteractor.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 11/18/24.
//

import Foundation

final class CoachingStore: Store, ObservableObject {
    
    var service: CoachingServiceProtocol
    @Published var state: State
    
    init(service: CoachingServiceProtocol,
         diaryResponse: PostDiaryResponse) {
        self.service = service
        self.state = State(diaryResponse: diaryResponse)
    }
    
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
                    state.detailDiaryResponse = try await service.detailDiaryAPI(diaryID: ID)
                } catch _ {
//                    state.toastMessage = "일단 에러"
                }
            }
        case .coachingButton(let ID):
            Task {
                do {
                    state.hiddenIndex += 1
                    state.coachingResponse = try await service.coachingPostAPI(diaryID: ID)
                    state.hiddenIndex += 1
                } catch _ {
//                    state.toastMessage = "일단 에러"
                }
            }
        }
    }
}


