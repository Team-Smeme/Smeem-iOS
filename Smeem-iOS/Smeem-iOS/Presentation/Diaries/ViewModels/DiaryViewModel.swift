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
    
    var topicID: Int? = nil
    var topicContent: String?
    var diaryID: Int?
    var badgePopupContent: [PopupBadge]?
    var isTopicCalled: Bool = false
    var hintText: String?
    var keyboardInfo: KeyboardInfo?
    
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
    
    func getTopicID() -> Int {
        return topicID ?? 0
    }
    
    func getInputText() -> String {
        return inputText.value
    }
    
    func isTextValid(text: String, viewType: DiaryViewType) -> Bool {
        guard let textView = SmeemTextViewHandler.shared.textView as? SmeemTextView else { return false
        }
        
        let placeholderText = textView.placeholderTextForViewType(for: viewType)
        
        if text == placeholderText {
            return false
        } else {
            switch viewType {
            case .foregin, .stepTwoKorean, .edit:
                return SmeemTextViewHandler.shared.containsEnglishCharacters(with: text)
            case .stepOneKorean:
                return SmeemTextViewHandler.shared.containsKoreanCharacters(with: text)
            }
        }
    }
}

// MARK: - Network

extension DiaryViewModel {
    func randomSubjectWithAPI() {
        RandomSubjectAPI.shared.getRandomSubject { [weak self] response in
            guard let strongSelf = self,
                  let randomSubjectData = response?.data else { return }
            
            strongSelf.topicID = randomSubjectData.topicId
            strongSelf.topicContent = randomSubjectData.content
            strongSelf.onUpdateTopicContent.value = randomSubjectData.content
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
