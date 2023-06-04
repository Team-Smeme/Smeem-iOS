//
//  DiaryStrategies.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/05.
//

import UIKit

class ForeignDiaryStrategy: DiaryStrategy {
    func configureLanguageLabel(_ label: UILabel) {
        label.text = "English"
    }
    
    func configureRightNavigationButton(_ button: UIButton) {
        button.setTitle("완료", for: .normal)
    }
}

class StepOneKoreanDiaryStrategy: DiaryStrategy {
    
    func configureLanguageLabel(_ label: UILabel) {
        label.text = "한국어"
    }
    
    func configureRightNavigationButton(_ button: UIButton) {
        button.setTitle("다음", for: .normal)
    }
}

class StepTwoKoreanDiaryStrategy: DiaryStrategy {
    func configureLanguageLabel(_ label: UILabel) {
        label.text = "한국어"
    }
    
    func configureRightNavigationButton(_ button: UIButton) {
        button.setTitle("다음", for: .normal)
    }
}
