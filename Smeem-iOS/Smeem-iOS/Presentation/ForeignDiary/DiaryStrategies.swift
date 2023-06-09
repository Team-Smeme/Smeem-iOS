//
//  DiaryStrategies.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/05.
//

import UIKit

// MARK: - ForeignDiaryStrategy

final class ForeignDiaryStrategy: DiaryStrategy {
    
    func configureToolTipView(_ imageView: UIImageView) {
        imageView.isHidden = false
    }
    
    func configureRandomSubjectButton(_ button: UIButton) {
        button.isEnabled = true
    }
    
    func configureLanguageLabel(_ label: UILabel) {
        label.text = "English"
    }
    
    func configureRightNavigationButton(_ button: UIButton) {
        button.setTitle("완료", for: .normal)
    }
    
    func configureStepLabel(_ label: UILabel) {
        label.text = ""
    }
}

// MARK: - StepOneKoreanDiaryStrategy

final class StepOneKoreanDiaryStrategy: DiaryStrategy {
    
    func configureToolTipView(_ imageView: UIImageView) {
        imageView.isHidden = false
    }
    
    func configureRandomSubjectButton(_ button: UIButton) {
        button.isEnabled = true
    }
    
    func configureLanguageLabel(_ label: UILabel) {
        label.text = "한국어"
    }
    
    func configureRightNavigationButton(_ button: UIButton) {
        button.setTitle("다음", for: .normal)
    }
    
    func configureStepLabel(_ label: UILabel) {
        label.text = "STEP1"
    }
}

// MARK: - StepTwoKoreanDiaryStrategy

final class StepTwoKoreanDiaryStrategy: DiaryStrategy {
    
    func configureToolTipView(_ imageView: UIImageView) {
        imageView.isHidden = true
    }
    
    func configureRandomSubjectButton(_ button: UIButton) {
        button.isEnabled = false
        button.setImage(Constant.Image.btnRandomSubjectEnabled, for: .normal)
    }
    
    func configureLanguageLabel(_ label: UILabel) {
        label.text = "English"
    }
    
    func configureRightNavigationButton(_ button: UIButton) {
        button.setTitle("완료", for: .normal)
    }
    
    func configureStepLabel(_ label: UILabel) {
        label.text = "STEP2"
    }
}
