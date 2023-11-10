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
    
    var randomTopicEnabled: Bool = false {
        didSet {
            onUpdateRandomTopic?(randomTopicEnabled)
        }
    }
    
    var isTextValid: Bool = false {
        didSet {
            onUpdateTextValidation?(isTextValid)
        }
    }
    
    var inputText: String = "" {
        didSet {
            onUpdateInputText?(inputText)
        }
    }
    
    var isHintShowed: Bool = false {
        didSet {
            onUpdateHintButton?(isHintShowed)
        }
    }
    
    var onUpdateRandomTopic: ((Bool) -> Void)?
    var onUpdateTextValidation: ((Bool) -> Void)?
    var onUpdateHintButton: ((Bool) -> Void)?
    var onUpdateTopicContent: ((String) -> Void)?
    var onUpdateInputText: ((String) -> Void)?
    var onUpdateTopicID: ((String) -> Void)?
    
    var topicID: String? = nil
    var topicContent: String?
    var diaryID: Int?
    var badgePopupContent: [PopupBadge]?
    var isTopicCalled: Bool = false
    var hintText: String?
    var keyboardInfo: KeyboardInfo?
}

// MARK: - Extensions

extension DiaryViewModel {
    func updateTextValidation(_ isValid: Bool) {
        isTextValid = isValid
    }
    
    func toggleRandomTopic() {
        randomTopicEnabled = !randomTopicEnabled
    }
    
    func toggleIsHintShowed() {
        isHintShowed = !isHintShowed
    }
    
    func getTopicID() -> String {
        return topicID ?? "null"
    }
    
    func getInputText() -> String {
        return inputText
    }
}

// MARK: - Network

extension DiaryViewModel {
    func randomSubjectWithAPI() {
        RandomSubjectAPI.shared.getRandomSubject { [weak self] response in
            guard let strongSelf = self,
                  let randomSubjectData = response?.data,
                  let topicContent = strongSelf.topicContent else { return }
            
            strongSelf.topicID = randomSubjectData.topicId
            strongSelf.topicContent = randomSubjectData.content
            strongSelf.onUpdateTopicContent?(topicContent)
        }
    }
    
    func postDiaryAPI(completion: @escaping(PostDiaryResponse?) -> Void) {
        PostDiaryAPI.shared.postDiary(param: PostDiaryRequest(content: getInputText(), topicId: getTopicID())) { response in
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
