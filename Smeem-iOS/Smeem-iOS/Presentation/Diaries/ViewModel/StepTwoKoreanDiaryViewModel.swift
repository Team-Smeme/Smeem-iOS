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
        let hintButtonTapped: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let hintButtonAction: AnyPublisher<Void, Never>
    }
    
    func transform(input: Input) -> Output {
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
        
        return Output(hintButtonAction: hintButtonAction)
    }
}
