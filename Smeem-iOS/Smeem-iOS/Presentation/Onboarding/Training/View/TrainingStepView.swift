//
//  FirstOnboardingView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/10/08.
//

import UIKit

enum TrainingStep {
    case goal
    case way
    case alarm
}

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
    
    init(type: TrainingStep) {
        super.init(frame: .zero)
        
        setComponentText(type: type)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setComponentText(type: TrainingStep) {
        switch type {
        case .goal:
            nowStepOneLabel.text = "1"
            titleTrainingLabel.text = "트레이닝 목표 설정"
            detailTrainingLabel.text = "마이페이지에서 언제든지 수정할 수 있어요"
        case .way:
            nowStepOneLabel.text = "2"
            titleTrainingLabel.text = "추천 트레이닝 방법"
            detailTrainingLabel.text = "스밈과 함께한다면 분명 목표를 이룰 거예요"
        case .alarm:
            nowStepOneLabel.text = "3"
            titleTrainingLabel.text = "트레이닝 시간 설정"
            detailTrainingLabel.text = "당신의 목표를 이룰 수 있도록 알림을 드릴게요!"
        }
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
