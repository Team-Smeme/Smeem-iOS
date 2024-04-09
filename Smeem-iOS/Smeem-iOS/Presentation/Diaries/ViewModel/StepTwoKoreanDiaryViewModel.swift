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
        let errorResult: AnyPublisher<SmeemError, Never>
        let loadingViewAction: AnyPublisher<Bool, Never>
    }
    
    private (set) var diaryPostedSubject = CurrentValueSubject<PostDiaryResponse?, Never>(nil)
    private let loadingViewResult = PassthroughSubject<Bool, Never>()
    private let errorResult = PassthroughSubject<SmeemError, Never>()
    
    func transform(input: Input) -> Output {
        let leftButtonAction = input.leftButtonTapped
            .eraseToAnyPublisher()
        
        let rightButtonAction = input.rightButtonTapped
            .handleEvents(receiveSubscription: { [weak self] _ in
                self?.loadingViewResult.send(true)
            })
            .flatMap { [weak self] _ -> AnyPublisher<Void, Never> in
                if self?.isRandomTopicActive.value == false {
                    self?.updateTopicID(topicID: nil)
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
                            promise(.success(()))
                        case .failure(let error):
                            self?.errorResult.send(error)
                        }
                    }
                }
                .handleEvents(receiveCompletion: { [weak self] _ in
                    self?.loadingViewResult.send(false)
                })
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let hintButtonAction = input.hintButtonTapped
            .map { [weak self] _ in
//                self?.postDeepLApi(diaryText: )
//                                AmplitudeManager.shared.track(event: AmplitudeConstant.diary.hint_click.event)
            }
            .eraseToAnyPublisher()
        
        let koreanDiaryResult = diaryTextSubject.eraseToAnyPublisher()
        let errorResult = errorResult.eraseToAnyPublisher()
        let loadingViewResult = loadingViewResult.eraseToAnyPublisher()
        
        return Output(leftButtonAction: leftButtonAction,
                      rightButtonAction: rightButtonAction,
                      hintButtonAction: hintButtonAction, 
                      koreanDiaryResult: koreanDiaryResult,
                      errorResult: errorResult,
                      loadingViewAction: loadingViewResult)
    }
}
