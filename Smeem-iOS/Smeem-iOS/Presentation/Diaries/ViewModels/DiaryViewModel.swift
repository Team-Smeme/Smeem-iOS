//
//  DiaryViewModel.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/11/02.
//

import UIKit

struct KeyboardInfo {
    var isKeyboardVisible: Bool = false
    var keyboardHeight: CGFloat = 0.0
}

// MARK: - DiaryViewModel

class DiaryViewModel {
    
    private (set) var isRandomTopicActive: Observable<Bool> = Observable(false)
    private (set) var isTextValid: Observable<Bool> = Observable(false)
    private (set) var inputText: Observable<String> = Observable("")
    private (set) var isHintShowed: Observable<Bool> = Observable(false)
    private (set) var onUpdateRandomTopic: Observable<Bool> = Observable(false)
    private (set) var onUpdateTopicContent: Observable<String> = Observable("")
    private (set) var keyboardInfo: Observable<KeyboardInfo?> = Observable(nil)
    private (set) var toastType: Observable<ToastViewType?> = Observable(nil)
    
    var topicID: Int? = nil
    var topicContent: String?
    var diaryID: Int?
    var badgePopupContent: [PopupBadge]?
    var isTopicCalled: Bool = false
    var hintText: String?
    
    var onUpdateTextValidation: ((Bool) -> Void)?
    var onUpdateHintButton: ((Bool) -> Void)?
    var onUpdateInputText: ((String) -> Void)?
    var onUpdateTopicID: ((String) -> Void)?
    var onError: ((Error) -> Void)?
}

// MARK: - Extensions

extension DiaryViewModel {
    func updateTextValidation(_ isValid: Bool) {
        isTextValid.value = isValid
    }
    
    func toggleRandomTopic() {
        isRandomTopicActive.value = !isRandomTopicActive.value
    }
    
    func toggleIsHintShowed() {
        isHintShowed.value = !isHintShowed.value
    }
    
    func getTopicID() -> Int? {
        return topicID ?? nil
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
}

// MARK: - Action Helpers

extension DiaryViewModel {
    
    // MARK: TextValidation
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
}

// MARK: - Network

extension DiaryViewModel {
    func callRandomTopicAPI() {
        RandomTopicAPI.shared.getRandomSubject { [weak self] result in
            
            switch result {
            case .success(let response):
                
                self?.topicID = response.topicId
                self?.topicContent = response.content
                self?.onUpdateTopicContent.value = response.content
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
                self.diaryID = response.diaryID
                self.badgePopupContent = response.badges
                completion(response)
                
            case .failure(let error):
                self.onError?(error)
            }
        }
    }
}
