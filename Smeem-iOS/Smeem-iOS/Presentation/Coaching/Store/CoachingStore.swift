//
//  CoachingInteractor.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 11/18/24.
//

import Foundation

struct SurveryData {
    let userName: String?
    let cocahingCount: Int?
}

struct CoachingAppData {
    var currentIndex: Int
    var diaryText: String
    var corrections: [CoachingResponse]
    var correctResultText: String
}

enum CoachingAmplitude {
    case coachingButtonTapped(Bool)
    case exitButtonTapped(Bool)
    case coachingLoading
    case coachingResult
    case coachingSwipe(Int)
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
        case amplitudeInput(type: CoachingAmplitude)
    }
    
    struct State {
        var detailDiaryResponse = DetailDiaryResponse.empty
        var coachingAppData = CoachingAppData(currentIndex: 0,
                                              diaryText: "",
                                              corrections: CoachingsResponse.sample.corrections,
                                              correctResultText: "첨삭 중이에요")
        var surveyData: SurveryData? = nil
        var toastErrorMessage: SmeemError? = nil
        var toastMessage: SmeemToast? = .completed
        
        var diaryResponse: PostDiaryResponse
        
        var hiddenIndex: Int = 0
        var isEnabled: Bool = true
        var isLoadingView: Bool = true
    }
    
    func send(action: Action) {
        switch action {
        case .detailDiaryAPI(let ID):
            Task {
                do {
                    state.detailDiaryResponse = try await service.detailDiaryAPI(diaryID: ID)
                    state.isEnabled = state.detailDiaryResponse.correctionMaxCount-state.detailDiaryResponse.correctionCount == 0 ? false : true
                    state.isLoadingView = false
                } catch let error {
                    let error = error as? SmeemError
                    state.toastErrorMessage = error
                    state.isLoadingView = false
                }
            }
        case .coachingButton(let ID):
            Task {
                do {
                    state.hiddenIndex += 1
                    let coachingResponse = try await service.coachingPostAPI(diaryID: ID)
                    self.state.surveyData = SurveryData(userName: coachingResponse.username, cocahingCount: coachingResponse.totalCount)
                    state.coachingAppData = CoachingAppData(currentIndex: 0,
                                                            diaryText: combineCorrectionText(coachingResponse.corrections),
                                                            corrections: filiterCorrection(coachingResponse.corrections) ?? [],
                                                            correctResultText: correctTextResult(filiterCorrection(coachingResponse.corrections) ?? []))
                    state.hiddenIndex += 1
                } catch let error {
                    let error = error as? SmeemError
                    state.toastErrorMessage = error
                    state.hiddenIndex = 0
                }
            }
        case .amplitudeInput(let type):
            switch type {
            case .coachingButtonTapped(let isActive):
                AmplitudeManager.shared.track(event: AmplitudeConstant.coaching.coaching_try_click(isActive).event)
            case .exitButtonTapped(let isActive):
                AmplitudeManager.shared.track(event: AmplitudeConstant.coaching.coaching_exit_click(isActive).event)
            case .coachingLoading:
                AmplitudeManager.shared.track(event: AmplitudeConstant.coaching.coaching_load_view.event)
            case .coachingResult:
                AmplitudeManager.shared.track(event: AmplitudeConstant.coaching.coaching_result_view.event)
            case .coachingSwipe(let index):
                AmplitudeManager.shared.track(event: AmplitudeConstant.coaching.coaching_feedback_view(index+1).event)
            }
        }
    }
    
    func combineCorrectionText(_ response: [CoachingResponse]) -> String {
        return response.map{ $0.originalSentence }.joined(separator: " ")
    }
    
    func filiterCorrection(_ response: [CoachingResponse]) -> [CoachingResponse]? {
        return response.filter { $0.isCorrected }.prefix(10).map{$0}
    }
    
    func correctTextResult(_ response: [CoachingResponse]) -> String {
        switch response.count {
        case 0:
            return "완벽한 일기예요!👍\n문장이 자연스럽고 오류가 없어요."
        case 1:
            return "잘 작성했어요!🙌\n작은 부분만 다듬으면 완벽해요."
        case 2...:
            return "대단해요!🥳🎉\n몇 가지 피드백을 준비해 봤어요."
        default:
            return "완벽한 일기예요!👍\n문장이 자연스럽고 오류가 없어요."
        }
    }
}


