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
        let hintTextsubject: PassthroughSubject<String, Never>
    }
    
    struct Output {
        let leftButtonAction: AnyPublisher<Void, Never>
        let rightButtonAction: AnyPublisher<Void, Never>
        let hintButtonAction: AnyPublisher<Void, Never>
        let koreanDiaryResult: AnyPublisher<String?, Never>
    }
    
    func transform(input: Input) -> Output {
        let leftButtonAction = input.leftButtonTapped
            .eraseToAnyPublisher()
        
        let rightButtonAction = input.rightButtonTapped
            .eraseToAnyPublisher()
        
        let hintButtonAction = input.hintButtonTapped
            .map { [weak self] _ in
//                self?.postDeepLApi(diaryText: )
//                                AmplitudeManager.shared.track(event: AmplitudeConstant.diary.hint_click.event)
            }
            .eraseToAnyPublisher()
        
        let koreanDiaryResult = diaryTextSubject.eraseToAnyPublisher()
        
        return Output(leftButtonAction: leftButtonAction,
                      rightButtonAction: rightButtonAction,
                      hintButtonAction: hintButtonAction, 
                      koreanDiaryResult: koreanDiaryResult)
    }
}
