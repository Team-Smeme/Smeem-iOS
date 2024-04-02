//
//  StepTwoKoreanDiaryViewModel.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2024/03/12.
//

import Foundation
import Combine

final class StepTwoKoreanDiaryViewModel: DiaryViewModel {
    struct Input {
        let leftButtonTapped: PassthroughSubject<Void, Never>
        let rightButtonTapped: PassthroughSubject<Void, Never>
        let hintButtonTapped: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let leftButtonAction: AnyPublisher<Void, Never>
        let rightButtonAction: AnyPublisher<Void, Never>
        let hintButtonAction: AnyPublisher<Void, Never>
    }
    
    func transform(input: Input) -> Output {
        let leftButtonAction = input.leftButtonTapped
            .eraseToAnyPublisher()
        
        let rightButtonAction = input.rightButtonTapped
            .eraseToAnyPublisher()
        
        let hintButtonAction = input.hintButtonTapped
            .map { 
//                if self.onUpdateHintButton.value == true {
////                    self.postDeepLApi(diaryText: rootView.configuration.layoutConfig?.getHintViewText() ?? "")
//                } else {
////                    rootView.configuration.layoutConfig?.hintTextView.text = viewModel.model.hintText
//                }
//                //                AmplitudeManager.shared.track(event: AmplitudeConstant.diary.hint_click.event)
            }
            .eraseToAnyPublisher()
        
        return Output(leftButtonAction: leftButtonAction,
                      rightButtonAction: rightButtonAction,
                      hintButtonAction: hintButtonAction)
    }
}
