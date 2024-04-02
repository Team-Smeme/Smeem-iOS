//
//  ForeignDiaryViewModel.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2024/03/12.
//

import Foundation
import Combine

final class ForeignDiaryViewModel: DiaryViewModel {
    struct Input {
        let leftButtonTapped: PassthroughSubject<Void, Never>
        let rightButtonTapped: PassthroughSubject<Void, Never>
        let randomTopicButtonTapped: PassthroughSubject<Void, Never>
        let refreshButtonTapped: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let leftButtonAction: AnyPublisher<Void, Never>
        let rightButtonAction: AnyPublisher<Void, Never>
        let randomTopicButtonAction: AnyPublisher<Void, Never>
        let refreshButtonAction: AnyPublisher<Void, Never>
    }
    
    func transform(input: Input) -> Output {
        let leftButtonAction = input.leftButtonTapped
            .eraseToAnyPublisher()
        
        let rightButtonAction = input.rightButtonTapped
            .map {
                if self.onUpdateTextValidation.value == true {
                    if self.isRandomTopicActive.value == false {
                        self.updateTopicID(topicID: nil)
                    }
//                    inputText.value = rootView.inputTextView.text ?? ""
//                    postDiaryAPI { postDiaryResponse in
//                        self.handlePostDiaryResponse(postDiaryResponse)
//                    }
                    AmplitudeManager.shared.track(event: AmplitudeConstant.diary.diary_complete.event)
                } else {
//                    showRegExToast()
                }
            }
            .eraseToAnyPublisher()
        
        
        let randomTopicButtonAction = input.randomTopicButtonTapped
            .flatMap { [unowned self] _ -> AnyPublisher<Void, Never> in
                self.isRandomTopicActive.value.toggle()
                
                if self.isRandomTopicActive.value {
                    if self.model.topicContent?.isEmpty == nil {
                        self.callRandomTopicAPI()
                    }
                } else {
                    self.updateModel(isTopicCalled: false, topicContent: nil)
                }
                return Just<Void>(()).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let refreshButtonAction = input.refreshButtonTapped
            .map {
                self.callRandomTopicAPI()
            }
            .eraseToAnyPublisher()
        
        return Output(leftButtonAction: leftButtonAction,
                      rightButtonAction: rightButtonAction,
                      randomTopicButtonAction: randomTopicButtonAction,
                      refreshButtonAction: refreshButtonAction)
    }
}
