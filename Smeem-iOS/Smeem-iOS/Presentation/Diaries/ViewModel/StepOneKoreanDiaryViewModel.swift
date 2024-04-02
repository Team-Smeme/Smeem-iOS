//
//  StepOneKoreanDiaryViewModel.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2024/03/12.
//

import Foundation
import Combine

final class StepOneKoreanDiaryViewModel: DiaryViewModel {
    struct Input {
        let randomTopicButtonTapped: PassthroughSubject<Void, Never>
        let refreshButtonTapped: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let randomTopicButtonAction: AnyPublisher<Void, Never>
        let refreshButtonAction: AnyPublisher<Void, Never>
    }
    
    func transform(input: Input) -> Output {
        let randomTopicButtonAction = input.randomTopicButtonTapped
            .flatMap{ [unowned self] _ -> AnyPublisher<Void, Never> in
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
        
        return Output(randomTopicButtonAction: randomTopicButtonAction, refreshButtonAction: refreshButtonAction)
    }
}

