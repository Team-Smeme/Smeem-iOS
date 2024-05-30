//
//  StepTwoKoreanDiaryViewModel.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2024/03/12.
//

import Foundation
import Combine

enum AmplitudeType {
    case secStepComplete
    case hintClick
}

final class StepTwoKoreanDiaryViewModel: DiaryViewModel {
    struct Input {
        let rightButtonTapped: PassthroughSubject<Void, Never>
        let hintButtonTapped: PassthroughSubject<Bool, Never>
        let hintTextsubject: PassthroughSubject<String, Never>
    }
    
    struct Output {
        let rightButtonAction: AnyPublisher<PostDiaryResponse?, Never>
        let hintButtonAction: AnyPublisher<Bool, Never>
        let postHintResult: AnyPublisher<String?, Never>
        let toastValidationResult: AnyPublisher<CGFloat, Never>
        let errorResult: AnyPublisher<SmeemError, Never>
        let loadingViewAction: AnyPublisher<Bool, Never>
    }
    
    private let amplitudeSubject = PassthroughSubject<AmplitudeType, Never>()
    private let postHintResult = PassthroughSubject<String?, Never>()
    private let toastValidationSubject = PassthroughSubject<CGFloat, Never>()
    private let loadingViewResult = PassthroughSubject<Bool, Never>()
    private let errorResult = PassthroughSubject<SmeemError, Never>()
    
    private var cancelBag = Set<AnyCancellable>()
    
    private var hintText = String()
    private var translatedText: String = ""
    private var isHintShowed = Bool()
    
    func transform(input: Input) -> Output {
        input.hintTextsubject
            .sink { [weak self] text in
                self?.hintText = text
            }
            .store(in: &cancelBag)
        
        let rightButtonAction = input.rightButtonTapped
            .filter { [weak self] in
                if self?.textValidationState.value == true {
                    return true
                } else {
                    self?.toastValidationSubject.send((self?.keyboardHeight) ?? 336.0)
                    return false
                }
            }
            .handleEvents(receiveSubscription: { [weak self] _ in
                self?.loadingViewResult.send(true)
            })
            .flatMap { [weak self] _ -> AnyPublisher<PostDiaryResponse?, Never> in
                return Future<PostDiaryResponse?, Never> { promise in
                    guard let inputText = self?.getDiaryText() else { return }
                    let topicID = SharedDiaryDataService.shared.topicID
                    
                    PostDiaryAPI.shared.postDiary(param: PostDiaryRequest(content: inputText, topicId: topicID)) { result in
                        switch result {
                        case .success(let response):
                            self?.updateDiaryInfo(diaryID: response.diaryID, badgePopupContent: response.badges)
                            promise(.success(response))
                            self?.amplitudeSubject.send(.secStepComplete)
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
            .map { [weak self] _ -> Bool in
                self?.isHintShowed.toggle()
                if self?.translatedText == "" {
                    self?.postDeepLApi(diaryText: self?.hintText ?? "")
                }

                self?.amplitudeSubject.send(.hintClick)
                self?.translatedText = ""
                return self?.isHintShowed ?? false
            }
            .eraseToAnyPublisher()
        
        let postHintResult = postHintResult
            .eraseToAnyPublisher()
        
        amplitudeSubject
            .sink { type in
                switch type {
                case .secStepComplete:
                    AmplitudeManager.shared.track(event: AmplitudeConstant.diary.sec_step_complete.event)
                case .hintClick:
                    AmplitudeManager.shared.track(event: AmplitudeConstant.diary.hint_click.event)
                }
            }
            .store(in: &cancelBag)
        
        let errorResult = errorResult.eraseToAnyPublisher()
        let loadingViewResult = loadingViewResult.eraseToAnyPublisher()
        let toastValidationResult = toastValidationSubject.eraseToAnyPublisher()
        
        return Output(rightButtonAction: rightButtonAction,
                      hintButtonAction: hintButtonAction,
                      postHintResult: postHintResult,
                      toastValidationResult: toastValidationResult,
                      errorResult: errorResult,
                      loadingViewAction: loadingViewResult)
    }
}

// MARK: - Network

extension StepTwoKoreanDiaryViewModel {
    private func postDeepLApi(diaryText: String) {
        DeepLAPI.shared.postTargetText(text: diaryText) { [weak self] result in
            switch result {
            case .success(let response):
                self?.translatedText = response?.translations.first?.text ?? ""
                self?.postHintResult.send(self?.translatedText)
            case .failure(let error):
                self?.errorResult.send(error)
            }
        }
    }
}
