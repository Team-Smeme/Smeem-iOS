//
//  DiaryStrategies.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/05.
//

import UIKit

// MARK: - ForeignDiaryStrategy

final class ForeignDiaryStrategy: DiaryStrategy {
    func configureRandomSubjectButtonImage(_ button: UIButton) {
        button.setImage(Constant.Image.btnRandomSubjectInactive, for: .normal)
    }
    
    func configurePlaceHolder(_ textView: UITextView) {
        textView.text = "일기를 작성해주세요."
    }
    
    func configureToolTipView(_ imageView: UIImageView) {
        imageView.isHidden = false
    }
    
    func configureRandomSubjectButton(_ button: UIButton) {
        button.isEnabled = true
    }
    
    func configureLanguageLabel(_ label: UILabel) {
        label.text = "English"
    }
    
    func configureLeftNavigationButton(_ button: UIButton) {
        button.setTitle("취소", for: .normal)
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
    func configureRandomSubjectButtonImage(_ button: UIButton) {
        button.setImage(Constant.Image.btnRandomSubjectInactive, for: .normal)
    }
    
    func configurePlaceHolder(_ textView: UITextView) {
        textView.text = "완전한 문장으로 한국어 일기를 작성하면, 더욱 정확한\n힌트를 받을 수 있어요."
    }
    
    func configureToolTipView(_ imageView: UIImageView) {
        imageView.isHidden = false
    }
    
    func configureRandomSubjectButton(_ button: UIButton) {
        button.isEnabled = true
    }
    
    func configureLanguageLabel(_ label: UILabel) {
        label.text = "한국어"
    }
    
    func configureLeftNavigationButton(_ button: UIButton) {
        button.setTitle("취소", for: .normal)
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
    func configureRandomSubjectButtonImage(_ button: UIButton) {
        func configureRandomSubjectButtonImage(_ button: UIButton) {
            button.setImage(Constant.Image.btnRandomSubjectEnabled, for: .normal)
        }
    }
    
    func configurePlaceHolder(_ textView: UITextView) {
        textView.text = "일기를 작성해주세요."
    }
    
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
    
    func configureLeftNavigationButton(_ button: UIButton) {
        button.setBackgroundImage(Constant.Image.icnBack, for: .normal)
    }
    
    func configureRightNavigationButton(_ button: UIButton) {
        button.setTitle("완료", for: .normal)
    }
    
    func configureStepLabel(_ label: UILabel) {
        label.text = "STEP2"
    }
}
