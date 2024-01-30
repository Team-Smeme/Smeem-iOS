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
    func randomSubjectWithAPI() {
        RandomSubjectAPI.shared.getRandomSubject { [weak self] response in
            guard let randomSubjectData = response?.data else { return }
            
            self?.topicID = randomSubjectData.topicId
            self?.topicContent = randomSubjectData.content
            self?.onUpdateTopicContent.value = randomSubjectData.content
        }
    }
    
    func postDiaryAPI(completion: @escaping(PostDiaryResponse?) -> Void) {
        
        let inputText = inputText.value
        
        PostDiaryAPI.shared.postDiary(param: PostDiaryRequest(content: inputText, topicId: getTopicID())) { response in
            
            guard let postDiaryResponse = response?.data else {
                completion(nil)
                return
            }
            
            self.diaryID = postDiaryResponse.diaryID
            self.badgePopupContent = postDiaryResponse.badges
            completion(postDiaryResponse)
        }
    }
}
