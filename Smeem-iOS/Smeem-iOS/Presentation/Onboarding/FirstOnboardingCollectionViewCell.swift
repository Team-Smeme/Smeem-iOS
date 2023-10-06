//
//  FirstOnboardingCollectionViewCell.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/10/06.
//

import UIKit

enum OnboardingType {
    case planGoal
    case howLearning
    case alarm
}

final class FirstOnboardingCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    
    private let onboardingType: OnboardingType
    private let firstOnboardingFactory: FirstOnboardingFactory
    
    // MARK: UI Properties
    
    private let nowStepOneLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = .s1
        label.setTextWithLineHeight(lineHeight: 21)
        label.textColor = .point
        return label
    }()
    
    private let divisionLabel: UILabel = {
        let label = UILabel()
        label.text = "/"
        label.font = .c3
        label.textColor = .black
        return label
    }()
    
    private let totalStepLabel: UILabel = {
        let label = UILabel()
        label.text = "3"
        label.font = .c3
        label.textColor = .black
        return label
    }()
    
    private let titleLearningLabel: UILabel = {
        let label = UILabel()
        label.font = .h2
        label.textColor = .black
        return label
    }()
    
    private let detailLearningLabel: UILabel = {
        let label = UILabel()
        label.font = .b4
        label.textColor = .black
        return label
    }()
    
    private let learningLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 6
        return stackView
    }()
    
    private lazy var nextButton: SmeemButton = {
        let button = SmeemButton()
        button.smeemButtonType = .notEnabled
        button.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: Life Cycle
    
    init(frame: CGRect, onboardingType: OnboardingType, firstOnboardingFatory: FirstOnboardingFactory) {
        self.onboardingType = onboardingType
        self.firstOnboardingFactory = firstOnboardingFatory
        
        super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func nextButtonDidTap() {
        
    }

    private func setComponent() {
        // 지금 이런 코드만 작성할 수 있음
        switch onboardingType {
        case .planGoal:
            let data = firstOnboardingFactory.createPlanGoalCell()
            nowStepOneLabel.text = data.stepText
            titleLearningLabel.text = data.titleLearningText
            detailLearningLabel.text = data.detailLearningText
            nextButton.setTitle(data.titleLearningText, for: .normal)
        case .howLearning:
            let data = firstOnboardingFactory.createHowTrainingCell()
            nowStepOneLabel.text = data.stepText
            titleLearningLabel.text = data.titleLearningText
            detailLearningLabel.text = data.detailLearningText
            nextButton.setTitle(data.titleLearningText, for: .normal)
        case .alarm:
            let data = firstOnboardingFactory.createTrainingAlarmCell()
            nowStepOneLabel.text = data.stepText
            titleLearningLabel.text = data.titleLearningText
            detailLearningLabel.text = data.detailLearningText
            nextButton.setTitle(data.titleLearningText, for: .normal)
        }
    }
}
