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
    
    var onUpdateRandomTopic: ((Bool) -> Void)?
    var onUpdateTextValidation: ((Bool) -> Void)?
    var onUpdateHintButton: ((Bool) -> Void)?
    var onUpdateTopicContent: ((String) -> Void)?
    
    var topicID: String? = nil
    var topicContent: String?
    var diaryID: Int?
    var badgePopupContent: [PopupBadge]?
    var isTopicCalled: Bool = false
    var rightButtonFlag = false
    var isInitialInput = true
    var keyboardInfo: KeyboardInfo?
    
    // MARK: StepTwoKoreanDiaryVC
    
    var isHintShowed: Bool = false {
        didSet {
            onUpdateHintButton?(isHintShowed)
        }
    }
    
    var hintText: String?
}

// MARK: - Extensions

extension DiaryViewModel {
    func toggleRandomTopic() {
        randomTopicEnabled = !randomTopicEnabled
    }
    
    func updateTextValidation(_ isValid: Bool) {
        isTextValid = isValid
    }
    
    func toggleIsHintShowed() {
        isHintShowed = !isHintShowed
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
    
    func postDiaryAPI() {
        PostDiaryAPI.shared.postDiary(param: PostDiaryRequest(content: getInputText(), topicId: getTopicID())) { response in
            guard let postDiaryResponse = response?.data else { return }
            self.diaryID = postDiaryResponse.diaryID
            
            if !postDiaryResponse.badges.isEmpty {
                self.badgePopupContent = postDiaryResponse.badges
            } else {
                self.badgePopupContent = []
            }
            
            DispatchQueue.main.async {
                let homeVC = HomeViewController()
                homeVC.toastMessageFlag = true
                homeVC.badgePopupData = self.badgePopupContent ?? []
                //                self.randomSubjectToolTip = nil
                let rootVC = UINavigationController(rootViewController: homeVC)
                changeRootViewControllerAndPresent(rootVC)
            }
        }
    }
}
