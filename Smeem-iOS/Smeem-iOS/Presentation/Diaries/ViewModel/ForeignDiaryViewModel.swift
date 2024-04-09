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
        let amplitudeSubject: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let leftButtonAction: AnyPublisher<Void, Never>
        let rightButtonAction: AnyPublisher<Void, Never>
        let randomTopicButtonAction: AnyPublisher<Void, Never>
        let refreshButtonAction: AnyPublisher<Void, Never>
        let errorResult: AnyPublisher<SmeemError, Never>
        let loadingViewAction: AnyPublisher<Bool, Never>
    }
    
    private let postDiaryResponseSubject = PassthroughSubject<PostDiaryResponse?, Never>()
    private var postDiaryResponsePublisher: AnyPublisher<PostDiaryResponse?, Never> {
        postDiaryResponseSubject.eraseToAnyPublisher()
    }
    private let loadingViewAction = PassthroughSubject<Bool, Never>()
    private let errorResult = PassthroughSubject<SmeemError, Never>()
    
    private var cancelBag = Set<AnyCancellable>()
    
    func transform(input: Input) -> Output {
        input.amplitudeSubject
            .sink { _ in
                AmplitudeManager.shared.track(event: AmplitudeConstant.diary.diary_complete.event)
            }
            .store(in: &cancelBag)
        
        let leftButtonAction = input.leftButtonTapped
            .eraseToAnyPublisher()
        
        let rightButtonAction = input.rightButtonTapped
            .handleEvents(receiveSubscription: { [weak self] _ in
                self?.loadingViewAction.send(true)
            })
            .flatMap { [weak self] _ -> AnyPublisher<Void, Never> in
                if self?.isRandomTopicActive.value == false {
                    self?.updateTopicID(topicID: nil)
                }
                
                return Future<Void, Never> { promise in
                    guard let inputText = self?.topicContentSubject.value else {
                        promise(.success(()))
                        return
                    }
                    
                    PostDiaryAPI.shared.postDiary(param: PostDiaryRequest(content: inputText, topicId: self?.getTopicID())) { result in
                        switch result {
                        case .success(let response):
                            self?.updateDiaryInfo(diaryID: response.diaryID, badgePopupContent: response.badges)
                            self?.postDiaryResponseSubject.send(response)
                            promise(.success(()))
                        case .failure(let error):
                            self?.errorResult.send(error)
                        }
                    }
                }
                .handleEvents(receiveCompletion: { [weak self] _ in
                    self?.loadingViewAction.send(false)
                })
                .eraseToAnyPublisher()
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
                    self.updateTopicStatus(isTopicCalled: false, topicContent: nil)
                }
                return Just<Void>(()).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let refreshButtonAction = input.refreshButtonTapped
            .map {
                self.callRandomTopicAPI()
            }
            .eraseToAnyPublisher()
        
        let postDiaryResponseResult = postDiaryResponseSubject.eraseToAnyPublisher()
        let errorResult = errorResult.eraseToAnyPublisher()
        let loadingViewAction = loadingViewAction.eraseToAnyPublisher()
        
        return Output(leftButtonAction: leftButtonAction,
                      rightButtonAction: rightButtonAction,
                      randomTopicButtonAction: randomTopicButtonAction,
                      refreshButtonAction: refreshButtonAction,
                      errorResult: errorResult,
                      loadingViewAction: loadingViewAction)
    }
    
    override init(model: DiaryModel) {
        super.init(model: model)
        
        self.callRandomTopicAPI()
    }
}
