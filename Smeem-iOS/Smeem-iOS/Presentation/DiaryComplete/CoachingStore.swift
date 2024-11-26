//
//  CoachingInteractor.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 11/18/24.
//

import Foundation

struct CoachingAppData {
    var corrections: CoachingsResponse
    var correctResultText: String
}

final class CoachingStore: Store, ObservableObject {
    
    var service: CoachingServiceProtocol
    @Published var state: State
    
    init(service: CoachingServiceProtocol,
         diaryResponse: PostDiaryResponse) {
        self.service = service
        self.state = State(diaryResponse: diaryResponse)
    }
    
    enum Action {
        case detailDiaryAPI(diaryID: Int)
        case coachingButton(diaryID: Int)
    }
    
    struct State {
        var detailDiaryResponse = DetailDiaryResponse.empty
        var coachingAppData = CoachingAppData(corrections: CoachingsResponse.empty,
                                               correctResultText: "첨삭 중이에요")
        var toastMessage: SmeemError? = SmeemError.clientError
        var toastMessgaea: SmeemToast? = .completed
        
        var diaryResponse: PostDiaryResponse
        
        var hiddenIndex: Int = 0
    }
    
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
                    let coachingResponse = try await service.coachingPostAPI(diaryID: ID)
                    state.coachingAppData = CoachingAppData(corrections: coachingResponse,
                                                             correctResultText: correctTextResult(coachingResponse.corrections.count))
                    state.hiddenIndex += 1
                } catch _ {
//                    state.toastMessage = "일단 에러"
                }
            }
        }
    }
    
    func correctTextResult(_ count: Int) -> String {
        switch count {
        case 0:
            return "완벽한 일기예요! 문장이 자연스럽고 오류가 없어요"
        case 1:
            return "잘 작성했어요! 작은 부분만 다듬으면 완벽해요"
        case 2...:
            return "대단해요! 몇가지 피드백을 준비해봤어요."
        default:
            return "대단해요! 몇가지 피드백을 준비해봤어요."
        }
    }
}


