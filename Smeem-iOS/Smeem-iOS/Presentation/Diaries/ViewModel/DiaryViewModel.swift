//
//  DiaryViewModel.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/11/02.
//

import Foundation
import Combine

struct KeyboardInfo {
    var isKeyboardVisible: Bool = false
    var keyboardHeight: CGFloat = 0.0
}

// MARK: - DiaryViewModel

class DiaryViewModel: ViewModel {
    struct Input {
        var textDidChangeSubject: PassthroughSubject<String, Never>
    }
    
    struct Output {
        let textValidationAction: AnyPublisher<Bool, Never>
    }
    
    private (set) var model: DiaryModel
    private var cancelBag = Set<AnyCancellable>()
    
    private (set) var viewTypeSubject = CurrentValueSubject<DiaryViewType, Never>(.stepOneKorean)
    
    private var textValidationState = PassthroughSubject<Bool, Never>()
    
    private (set) var isRandomTopicActive = CurrentValueSubject<Bool, Never>(false)
    private (set) var topicContentSubject = CurrentValueSubject<String, Never>("")
    private (set) var onUpdateTextValidation: Observable<Bool> = Observable(false)
    private (set) var inputText: Observable<String> = Observable("")
    private (set) var keyboardInfo: Observable<KeyboardInfo?> = Observable(nil)
    private (set) var toastType: Observable<ToastViewType?> = Observable(nil)
//    private (set) var onUpdateTopicID: Observable<Int> = Observable(0)
    
    var onUpdateTopicID: ((String) -> Void)?
    var onError: ((Error) -> Void)?
    
    init(model: DiaryModel) {
        self.model = model
    }
    
    func transform(input: Input) -> Output {
        input.textDidChangeSubject
            .sink { [weak self] text in
                guard let viewType = self?.viewTypeSubject.value else {
                    return
                }
                let isValid = self?.validateText(with: text, viewType: viewType) ?? false
                
                self?.textValidationState.send(isValid)
            }
            .store(in: &cancelBag)
        
        let diaryTextAction = textValidationState.eraseToAnyPublisher()
        
        return Output(textValidationAction: diaryTextAction)
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
    
//    func toggleIsHintShowed() {
//        onUpdateHintButton.value = !onUpdateHintButton.value
//    }
    
    func getTopicID() -> Int? {
        return model.topicID ?? nil
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
    func validateText(with text: String, viewType: DiaryViewType) -> Bool {
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
}

// MARK: - Network

extension DiaryViewModel {
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
