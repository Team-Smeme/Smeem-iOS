//
//  DiaryViewModel.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/11/02.
//

import Combine
import UIKit

struct KeyboardInfo {
    var isKeyboardVisible: Bool = false
    var keyboardHeight: CGFloat = 0.0
}

// MARK: - DiaryViewModel

final class DiaryViewModel: ViewModel {
    // private으로 선언하면 어떨까요?
    struct Input {
        let onClickLeftButton = PassthroughSubject<Void, Never>()
        let onClickRightButton = PassthroughSubject<Void, Never>()
        let onClickRandomTopicButton = PassthroughSubject<Void, Never>()
        let onClickHintButton = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        let shouldDismiss: AnyPublisher<Void, Never>
        let shouldPostDiary: AnyPublisher<Void, Never>
    }
    
    private (set) var model: DiaryModel
    
    private (set) var isRandomTopicActive = CurrentValueSubject<Bool, Never>(false)
    private (set) var onUpdateTextValidation = CurrentValueSubject<Bool, Never>(false)
    private (set) var inputText = CurrentValueSubject<String, Never>("")
    private (set) var onUpdateHintButton = CurrentValueSubject<Bool, Never>(false)
    private (set) var onUpdateRandomTopic = CurrentValueSubject<Bool, Never>(false)
    private (set) var onUpdateTopicContent = CurrentValueSubject<String, Never>("")
    private (set) var keyboardInfo = CurrentValueSubject<KeyboardInfo?, Never>(nil)
    private (set) var toastType = CurrentValueSubject<ToastViewType?, Never>(nil)
    
//    private (set) var onUpdateTopicID: Observable<Int> = Observable(0)
    
    var onUpdateInputText: ((String) -> Void)?
    var onUpdateTopicID: ((String) -> Void)?
    var onError: ((Error) -> Void)?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(model: DiaryModel) {
        self.model = model
    }
}

// MARK: - Extensions

extension DiaryViewModel {
    func updateTextValidation(_ isValid: Bool) {
        onUpdateTextValidation.value = isValid
    }
    
    func toggleRandomTopic() {
        isRandomTopicActive.value = !isRandomTopicActive.value
    }
    
    func toggleIsHintShowed() {
        onUpdateHintButton.value = !onUpdateHintButton.value
    }
    
    func getTopicID() -> Int? {
        return model.topicID ?? nil
    }
    
    func getInputText() -> String {
        return inputText.value
    }
    
    func updateKeyboardInfo(info: KeyboardInfo) {
        keyboardInfo.value = info
    }
    
    func setToastViewType(_ type: ToastViewType) {
        toastType.value = type
    }
    
    func updateModel(isTopicCalled: Bool, topicContent: String?) {
        model.isTopicCalled = isTopicCalled
        model.topicContent = topicContent
    }
    
    func updateTopicID(topicID: Int?) {
        model.topicID = topicID
    }
    
    func updateHintText(hintText: String) {
        model.hintText = hintText
    }
}

// MARK: - Action Helpers

extension DiaryViewModel {
    func leftButtonTapped() {
        print("✅")
    }
    
    func rightButtonTapped() {
        
    }
    
    func isTextValid(text: String, viewType: DiaryViewType) -> Bool {
        let smeemTextViewHandler = SmeemTextViewHandler()
        
        let placeholderText = smeemTextViewHandler.placeholderTextForViewType(for: viewType)
        
        if text == placeholderText {
            return false
        } else {
            switch viewType {
            case .foregin, .stepTwoKorean, .edit:
                return smeemTextViewHandler.containsEnglishCharacters(with: text)
            case .stepOneKorean:
                return smeemTextViewHandler.containsKoreanCharacters(with: text)
            }
        }
    }
    
    func showRegExToast() {
        setToastViewType(.smeemToast(bodyType: .regEx))
    }
    
    func showRegExKrToast() {
        setToastViewType(.smeemToast(bodyType: .regExKr))
    }
    
    func transform(input: DiaryViewModel.Input) -> DiaryViewModel.Output {
        let shouldDismiss = input.onClickLeftButton
            .map { _ in Void() }
            .eraseToAnyPublisher()
        
        let shouldPostDiary = input.onClickRightButton
            .filter { [weak self] _ in self?.onUpdateTextValidation.value == true }
            .map { _ in Void() }
            .eraseToAnyPublisher()
        
        return Output(shouldDismiss: shouldDismiss, shouldPostDiary: shouldPostDiary)
    }
}

// MARK: - Network

extension DiaryViewModel {
    func callRandomTopicAPI() {
        RandomTopicAPI.shared.getRandomSubject { [weak self] result in
            
            switch result {
            case .success(let response):
                
                self?.model.topicID = response.topicId
                self?.model.topicContent = response.content
                self?.onUpdateTopicContent.value = response.content
            case .failure(let error):
                self?.onError?(error)
            }
        }
    }
    
    func postDiaryAPI(completion: @escaping(PostDiaryResponse?) -> Void) {
        
        PostDiaryAPI.shared.postDiary(param: PostDiaryRequest(content: getInputText(), topicId: getTopicID())) { result in
            
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
