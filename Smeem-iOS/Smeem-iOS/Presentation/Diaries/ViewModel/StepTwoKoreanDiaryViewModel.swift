//
//  StepTwoKoreanDiaryViewModel.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2024/03/12.
//

import Foundation
import Combine

final class StepTwoKoreanDiaryViewModel: ViewModel {
    struct Input {
        let hintButtonTapped: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let hintButtonAction: AnyPublisher<Void, Never>
    }
    
    private (set) var model: DiaryModel
    
    private (set) var inputText: Observable<String> = Observable("")
    private (set) var onUpdateHintButton: Observable<Bool> = Observable(false)
    private (set) var onUpdateTextValidation: Observable<Bool> = Observable(false)
    private (set) var toastType: Observable<ToastViewType?> = Observable(nil)
    
    var onError: ((Error) -> Void)?
    
    init(model: DiaryModel) {
        self.model = model
    }
    
    func transform(input: Input) -> Output {
        let hintButtonAction = input.hintButtonTapped
            .map { 
                if self.onUpdateHintButton.value == true {
//                    self.postDeepLApi(diaryText: rootView.configuration.layoutConfig?.getHintViewText() ?? "")
                } else {
//                    rootView.configuration.layoutConfig?.hintTextView.text = viewModel.model.hintText
                }
                //                AmplitudeManager.shared.track(event: AmplitudeConstant.diary.hint_click.event)
            }
            .eraseToAnyPublisher()
        
        return Output(hintButtonAction: hintButtonAction)
    }
}

extension StepTwoKoreanDiaryViewModel {
    func getTopicID() -> Int? {
        return model.topicID ?? nil
    }
    
    func updateTopicID(topicID: Int?) {
        model.topicID = topicID
    }
    
    func updateHintText(hintText: String) {
        model.hintText = hintText
    }
    
    func toggleIsHintShowed() {
        onUpdateHintButton.value = !onUpdateHintButton.value
    }
    
    func showRegExToast() {
        setToastViewType(.smeemToast(bodyType: .regEx))
    }
    
    func setToastViewType(_ type: ToastViewType) {
        toastType.value = type
    }
}

extension StepTwoKoreanDiaryViewModel {
    func postDiaryAPI(completion: @escaping(PostDiaryResponse?) -> Void) {
        
        let inputText = inputText.value
        
        PostDiaryAPI.shared.postDiary(param: PostDiaryRequest(content: inputText, topicId: getTopicID())) { result in
            
            switch result {
            case .success(let response):
                self.model.diaryID = response.diaryID
                self.model.badgePopupContent = response.badges
                completion(response)
                
            case .failure(let error):
                self.onError?(error)
            }
        }
    }
}
