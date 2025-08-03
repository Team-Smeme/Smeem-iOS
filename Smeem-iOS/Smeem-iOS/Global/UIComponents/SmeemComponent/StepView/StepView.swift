//
//  StepView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 4/7/25.
//

import UIKit

enum StepType {
    case step1
    case step2
}

class StepView: UIView {
    
    private var type = StepType.step1
    
    private let step1Label: UILabel = {
        let label = UILabel()
        label.font = .c4
        label.text = "STEP 1"
        return label
    }()
    
    private let koreanLabel: UILabel = {
        let label = UILabel()
        label.font = .b1
        label.text = "한국어"
        return label
    }()
    
    private let step1Line: UIView = {
        let view = UIView()
        return view
    }()
    
    private let stepImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constant.Image.icnStepImage
        return imageView
    }()
    
    private let step2Label: UILabel = {
        let label = UILabel()
        label.font = .c4
        label.textColor = .smeemBlack
        label.text = "STEP 2"
        return label
    }()
    
    private let englishLabel: UILabel = {
        let label = UILabel()
        label.font = .b1
        label.text = "한국어"
        return label
    }()
    
    private let step2Line: UIView = {
        let view = UIView()
        return view
    }()
    
    private let step1StackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.alignment = .leading
        return stackView
    }()
    
    private let step2StackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.alignment = .center
        return stackView
    }()
    
    private let TotalStepStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    init(type: StepType) {
        self.type = type
        super.init(frame: .zero)
        
        switch type {
        case .step1:
            step1Label.textColor = .smeemBlack
            koreanLabel.textColor = .smeemBlack
            step1Line.backgroundColor = .smeemBlack
            
            step2Label.textColor = .gray300
            koreanLabel.textColor = .gray300
            step1Line.backgroundColor = .clear
        case .step2:
            step1Label.textColor = .gray300
            koreanLabel.textColor = .gray300
            step1Line.backgroundColor = .clear
            
            step2Label.textColor = .smeemBlack
            koreanLabel.textColor = .smeemBlack
            step1Line.backgroundColor = .smeemBlack
        }

        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        step1StackView.addArrangedSubviews(step1Label, koreanLabel, step1Line)
        step2StackView.addArrangedSubviews(step2Label, englishLabel, step2Line)
        TotalStepStackView.addArrangedSubviews(step1StackView, stepImage, step2StackView)

        addSubview(TotalStepStackView)

        TotalStepStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        step1Line.snp.makeConstraints {
            $0.height.equalTo(2)
            $0.width.equalTo(koreanLabel)
        }

        step2Line.snp.makeConstraints {
            $0.height.equalTo(2)
            $0.width.equalTo(englishLabel)
        }
    }
    
}
