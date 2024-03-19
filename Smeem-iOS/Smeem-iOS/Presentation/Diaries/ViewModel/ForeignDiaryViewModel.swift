//
//  ForeignDiaryViewModel.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2024/03/12.
//

import Foundation
import Combine

final class ForeignDiaryViewModel: ViewModel {
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
    
    private (set) var model: DiaryModel
    
    var onError: ((Error) -> Void)?
    
    private (set) var isRandomTopicActive = CurrentValueSubject<Bool, Never>(false)
    private (set) var topicContentSubject = CurrentValueSubject<String, Never>("")
    private (set) var inputText: Observable<String> = Observable("")
    //    private (set) var inputText = CurrentValueSubject<String, Never>("")
    private (set) var onUpdateTextValidation: Observable<Bool> = Observable(false)
    
    init(model: DiaryModel) {
        self.model = model
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

extension ForeignDiaryViewModel {
    func getTopicID() -> Int? {
        return model.topicID ?? nil
    }
    
    func updateModel(isTopicCalled: Bool, topicContent: String?) {
        model.isTopicCalled = isTopicCalled
        model.topicContent = topicContent
    }
    
    func updateTopicID(topicID: Int?) {
        model.topicID = topicID
    }
}

extension ForeignDiaryViewModel {
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
