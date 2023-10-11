//
//  FirstOnboardingView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/10/08.
//

import UIKit

final class TrainingStepView: UIView {
    
    // MARK: Properties
    
    // MARK: UI Properties
    
    private let nowStepOneLabel: UILabel = {
        let label = UILabel()
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
    
    private let titleTrainingLabel: UILabel = {
        let label = UILabel()
        label.font = .h2
        label.textColor = .black
        return label
    }()
    
    private let detailTrainingLabel: UILabel = {
        let label = UILabel()
        label.font = .b4
        label.textColor = .black
        return label
    }()
    
    private let trainingLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 6
        return stackView
    }()
    
    // MARK: Life Cycle
    
    init(configuration: FirstOnboardingConfiguration) {
        super.init(frame: .zero)
        
        setComponentText(configuration: configuration)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setComponentText(configuration: FirstOnboardingConfiguration) {
        nowStepOneLabel.text = configuration.stepText
        titleTrainingLabel.text = configuration.titleLearningText
        detailTrainingLabel.text = configuration.detailLearningText
    }
}

// MARK: - Layout

extension TrainingStepView {
    private func setLayout() {
        addSubviews(nowStepOneLabel, divisionLabel, totalStepLabel,
                    trainingLabelStackView)
        trainingLabelStackView.addArrangedSubviews(titleTrainingLabel, detailTrainingLabel)
        
        nowStepOneLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(26)
            $0.top.equalToSuperview()
        }
        
        divisionLabel.snp.makeConstraints {
            $0.leading.equalTo(nowStepOneLabel.snp.trailing).offset(2)
            $0.top.equalToSuperview().inset(4)
        }
        
        totalStepLabel.snp.makeConstraints {
            $0.leading.equalTo(divisionLabel.snp.trailing).offset(1)
            $0.top.equalTo(divisionLabel.snp.top)
        }
        
        trainingLabelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(26)
            $0.top.equalTo(totalStepLabel.snp.bottom).offset(19)
        }
    }
}
