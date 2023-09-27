//
//  SmeemTextViewManager.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/09/26.
//

import UIKit

class SmeemTextViewManager {
    var diaryStrategy: DiaryStrategy?
    weak var diaryViewController: DiaryViewController?

    func validateText(_ text: String) -> Bool {
        guard let strategy = diaryStrategy else { return false }
        
        if let koreanStrategy = strategy as? StepOneKoreanDiaryStrategy {
            return koreanValidation(with: text)
        } else {
            return englishValidation(with: text)
        }
    }

    func englishValidation(with text: String) -> Bool {
        return text.getArrayAfterRegex(regex: "[a-zA-z]").count > 0
    }

    func koreanValidation(with text: String) -> Bool {
        return text.getArrayAfterRegex(regex: "[가-핳ㄱ-ㅎㅏ-ㅣ]").count > 0
    }
    
    func buttonColor(for isValid: Bool) -> UIColor {
        return isValid ? .point : .gray300
    }
}
