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
        let hintButtonTapped: PassthroughSubject<Bool, Never>
        let hintTextsubject: PassthroughSubject<String, Never>
    }
    
    struct Output {
        let leftButtonAction: AnyPublisher<Void, Never>
        let rightButtonAction: AnyPublisher<Void, Never>
        let hintButtonAction: AnyPublisher<Bool, Never>
        let postHintResult: AnyPublisher<String?, Never>
        let koreanDiaryResult: AnyPublisher<String?, Never>
        let errorResult: AnyPublisher<SmeemError, Never>
        let loadingViewAction: AnyPublisher<Bool, Never>
    }
    
    private (set) var diaryPostedSubject = CurrentValueSubject<PostDiaryResponse?, Never>(nil)
    private let amplitudeSubject = PassthroughSubject<Void, Never>()
    private let postHintResult = PassthroughSubject<String?, Never>()
    private let loadingViewResult = PassthroughSubject<Bool, Never>()
    private let errorResult = PassthroughSubject<SmeemError, Never>()
    
    private var cancelBag = Set<AnyCancellable>()
    
    private var hintText = String()
    private var translatedText = String()
    private var isHintShowed = Bool()
    
    func transform(input: Input) -> Output {
        input.hintTextsubject
            .sink { [weak self] text in
                self?.hintText = text
            }
            .store(in: &cancelBag)
        
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
                            self?.amplitudeSubject.send()
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
        // TODO: unowned 고려해보기
            .map { [weak self] _ -> Bool in
                self?.isHintShowed.toggle()
                if self?.translatedText.isEmpty == true {
                    self?.postDeepLApi(diaryText: self?.hintText ?? "")
                }

                AmplitudeManager.shared.track(event: AmplitudeConstant.diary.hint_click.event)
                return self?.isHintShowed ?? false
            }
            .eraseToAnyPublisher()
        
        let postHintResult = postHintResult
            .eraseToAnyPublisher()
        
        amplitudeSubject
            .sink { _ in
                AmplitudeManager.shared.track(event: AmplitudeConstant.diary.sec_step_complete.event)
            }
            .store(in: &cancelBag)
        
        let koreanDiaryResult = diaryTextSubject.eraseToAnyPublisher()
        let errorResult = errorResult.eraseToAnyPublisher()
        let loadingViewResult = loadingViewResult.eraseToAnyPublisher()
        
        return Output(leftButtonAction: leftButtonAction,
                      rightButtonAction: rightButtonAction,
                      hintButtonAction: hintButtonAction,
                      postHintResult: postHintResult,
                      koreanDiaryResult: koreanDiaryResult,
                      errorResult: errorResult,
                      loadingViewAction: loadingViewResult)
    }
}

// MARK: - Extensions

extension StepTwoKoreanDiaryViewModel {
    func getIsHintShowed() -> Bool {
        return isHintShowed
    }
}

// MARK: - Network

extension StepTwoKoreanDiaryViewModel {
    private func postDeepLApi(diaryText: String) {
        DeepLAPI.shared.postTargetText(text: diaryText) { [weak self] response in
            self?.translatedText = response?.translations.first?.text ?? ""
            self?.postHintResult.send(self?.translatedText)
        }
    }
}
