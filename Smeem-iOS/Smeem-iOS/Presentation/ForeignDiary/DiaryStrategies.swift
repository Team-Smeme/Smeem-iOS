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
    
    func configureStepLabel(_ label: UILabel) {
        label.text = ""
    }
    
    func configureRandomSubjectButton(_ button: UIButton) {
        button.isEnabled = true
    }
}

class StepOneKoreanDiaryStrategy: DiaryStrategy {
    
    func configureLanguageLabel(_ label: UILabel) {
        label.text = "한국어"
    }
    
    func configureRightNavigationButton(_ button: UIButton) {
        button.setTitle("다음", for: .normal)
    }
    
    func configureStepLabel(_ label: UILabel) {
        label.text = "STEP1"
    }
    
    func configureRandomSubjectButton(_ button: UIButton) {
        button.isEnabled = true
    }
}

class StepTwoKoreanDiaryStrategy: DiaryStrategy {
    func configureLanguageLabel(_ label: UILabel) {
        label.text = "한국어"
    }
    
    func configureRightNavigationButton(_ button: UIButton) {
        button.setTitle("다음", for: .normal)
    }
    
    func configureStepLabel(_ label: UILabel) {
        label.text = "STEP2"
    }
    
    func configureRandomSubjectButton(_ button: UIButton) {
        button.isEnabled = false
    }
}
