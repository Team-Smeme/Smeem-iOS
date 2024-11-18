//
//  CocahingReducer.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 11/18/24.
//

import Foundation
import ComposableArchitecture

struct CoachingStore: Reducer {
    
    @ObservableState
    struct State: Equatable {
        var postDiarayResponse: PostDiaryResponse
        var detailDiaryResponse = DetailDiaryResponse.empty
    }
    
    enum Action: Equatable {
        case getDetailDiary(diaryID: Int)
        
        case setDetailDiary(response: DetailDiaryResponse)
    }
    
    @Dependency(\.coachingService) var coachingService
    
    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.Effect<Action> {
        switch action {
        case .getDetailDiary(let diaryID):
            return .run { send in
                let detailDiaryResponse = try await coachingService.detailDiaryAPI(diaryID: diaryID)
                await send(.setDetailDiary(response: detailDiaryResponse))
            }
        
        // MARK: setter
        case .setDetailDiary(let response):
            state.detailDiaryResponse = response
            return .none
        }
    }
    
}
