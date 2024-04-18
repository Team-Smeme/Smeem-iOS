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
        let viewDidLoadSubject: PassthroughSubject<Void, Never>
        let leftButtonTapped: PassthroughSubject<Void, Never>
        let rightButtonTapped: PassthroughSubject<Void, Never>
        let randomTopicButtonTapped: PassthroughSubject<Void, Never>
        let refreshButtonTapped: PassthroughSubject<Void, Never>
        let toolTipTapped: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let leftButtonAction: AnyPublisher<Void, Never>
        let rightButtonAction: AnyPublisher<Void, Never>
        let randomTopicButtonAction: AnyPublisher<Void, Never>
        let refreshButtonAction: AnyPublisher<Void, Never>
        let toolTipAction: AnyPublisher<Void, Never>
        let toolTipResult: AnyPublisher<Void, Never>
        let loadingViewResult: AnyPublisher<Bool, Never>
    }
    
    private (set) var diaryPostedSubject = CurrentValueSubject<PostDiaryResponse?, Never>(nil)
    private let toolTipSubject = PassthroughSubject<Void, Never>()
    private let amplitudeSubject = PassthroughSubject<Void, Never>()
    private let loadingViewResult = PassthroughSubject<Bool, Never>()
    
    private var cancelBag = Set<AnyCancellable>()
    
    override init(model: DiaryModel) {
        super.init(model: model)
    }
    
    func transform(input: Input) -> Output {
        input.viewDidLoadSubject
            .sink { [weak self] in
                self?.callRandomTopicAPI({})
                self?.toolTipSubject.send()
            }
            .store(in: &cancelBag)
        
        let leftButtonAction = input.leftButtonTapped
            .eraseToAnyPublisher()
        
        let rightButtonAction = input.rightButtonTapped
            .filter { [weak self] in self?.textValidationState.value == true }
            .handleEvents(receiveSubscription: { [weak self] _ in
                self?.loadingViewResult.send(true)
            })
            .flatMap { [weak self] _ -> AnyPublisher<Void, Never> in
                if self?.isRandomTopicActive.value == false {
                    self?.updateTopicID(to: nil)
                }
                
                return Future<Void, Never> { promise in
                    guard let inputText = self?.getDiaryText() else {
                        return
                    }
                    
                    PostDiaryAPI.shared.postDiary(param: PostDiaryRequest(content: inputText, topicId: self?.getTopicID())) { result in
                        switch result {
                        case .success(let response):
                            self?.updateDiaryInfo(diaryID: response.diaryID, badgePopupContent: response.badges)
                            self?.diaryPostedSubject.send(response)
                            self?.amplitudeSubject.send()
                            promise(.success(()))
                        case .failure(let error):
                            self?.sendError(error)
                        }
                    }
                }
                .handleEvents(receiveCompletion: { [weak self] _ in
                    self?.loadingViewResult.send(false)
                })
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let randomTopicButtonAction = input.randomTopicButtonTapped
            .flatMap { [weak self] _ -> AnyPublisher<Void, Never> in
                self?.isRandomTopicActive.value.toggle()
                
                if self?.isRandomTopicActive.value == false {
                    self?.updateTopicStatus(isTopicCalled: false, topicContent: nil)
                }
                return Just<Void>(()).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let refreshButtonAction = input.refreshButtonTapped
            .flatMap { [weak self] _ -> AnyPublisher<Void, Never> in
                Future { promise in
                    self?.callRandomTopicAPI({
                        promise(.success(()))
                    })
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let toolTipAction = input.toolTipTapped
            .handleEvents(receiveOutput:  { _ in
                UserDefaultsManager.shouldShowToolTip = false
            })
            .eraseToAnyPublisher()
        
        let toolTipResult = toolTipSubject
            .filter { _ in UserDefaultsManager.shouldShowToolTip == true }
            .eraseToAnyPublisher()
        
        amplitudeSubject
            .sink { _ in
                AmplitudeManager.shared.track(event: AmplitudeConstant.diary.diary_complete.event)
            }
            .store(in: &cancelBag)
        
        let loadingViewResult = loadingViewResult.eraseToAnyPublisher()
        
        return Output(leftButtonAction: leftButtonAction,
                      rightButtonAction: rightButtonAction,
                      randomTopicButtonAction: randomTopicButtonAction,
                      refreshButtonAction: refreshButtonAction,
                      toolTipAction: toolTipAction,
                      toolTipResult: toolTipResult,
                      loadingViewResult: loadingViewResult)
    }
}
