//
//  StepOneKoreanDiaryViewModel.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2024/03/12.
//

import Foundation
import Combine

final class StepOneKoreanDiaryViewModel: ViewModel {
    struct Input {
        let randomTopicButtonTapped: PassthroughSubject<Void, Never>
        let refreshButtonTapped: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let randomTopicButtonAction: AnyPublisher<Void, Never>
        let refreshButtonAction: AnyPublisher<Void, Never>
    }
    
    private (set) var model: DiaryModel
    
    private (set) var isRandomTopicActive = CurrentValueSubject<Bool, Never>(false)
    private (set) var topicContentSubject = CurrentValueSubject<String, Never>("")
    
    var onError: ((Error) -> Void)?
    
    init(model: DiaryModel) {
        self.model = model
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

extension StepOneKoreanDiaryViewModel {
    func updateModel(isTopicCalled: Bool, topicContent: String?) {
        model.isTopicCalled = isTopicCalled
        model.topicContent = topicContent
    }
}

extension StepOneKoreanDiaryViewModel {
    func callRandomTopicAPI() {
        RandomTopicAPI.shared.getRandomSubject { [weak self] result in
            
            switch result {
            case .success(let response):
                
                self?.model.topicID = response.topicId
                self?.model.topicContent = response.content
                self?.topicContentSubject.value = response.content
            case .failure(let error):
                self?.onError?(error)
            }
        }
    }
}

