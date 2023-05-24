//
//  AlarmSettingViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/16.
//

import UIKit

final class AlarmSettingViewController: UIViewController {
    
    // MARK: - Property
    
    // MARK: - UI Property
    
    private let nowStepOneLabel: UILabel = {
        let label = UILabel()
        label.text = "3"
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
    
    private let titleTimeSettingLabel: UILabel = {
        let label = UILabel()
        label.text = "학습 시간 설정"
        label.font = .h2
        label.textColor = .black
        return label
    }()
    
    private let deatilTimeSettingLabel: UILabel = {
        let label = UILabel()
        label.text = "잊지 않도록 알림을 드릴게요."
        label.font = .b4
        label.textColor = .black
        return label
    }()
    
    private let timeSettingLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 6
        return stackView
    }()
    
    private let laterButton: UIButton = {
        let button = UIButton()
        button.setTitle("나중에 설정하기", for: .normal)
        button.setTitleColor(.gray600, for: .normal)
        button.titleLabel?.font = .b4
        return button
    }()
    
    private let completeButton: SmeemButton = {
        let button = SmeemButton()
        button.setTitle("완료", for: .normal)
        return button
    }()
    
    private lazy var alarmCollectionView = AlarmCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        setLayout()
    }
    
    // MARK: - @objc
    
    // MARK: - Custom Method
    
    // MARK: - Layout
    
    private func setBackgroundColor() {
        view.backgroundColor = .smeemWhite
    }
    
    private func setLayout() {
        view.addSubviews(nowStepOneLabel, divisionLabel, totalStepLabel, timeSettingLabelStackView,
                         alarmCollectionView, laterButton, completeButton)
        timeSettingLabelStackView.addArrangedSubviews(titleTimeSettingLabel, deatilTimeSettingLabel)
        
        nowStepOneLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(26)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(36)
        }
        
        divisionLabel.snp.makeConstraints {
            $0.leading.equalTo(nowStepOneLabel.snp.trailing).offset(2)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(40)
        }
        
        totalStepLabel.snp.makeConstraints {
            $0.leading.equalTo(divisionLabel.snp.trailing).offset(1)
            $0.top.equalTo(divisionLabel.snp.top)
        }
        
        timeSettingLabelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(26)
            $0.top.equalTo(totalStepLabel.snp.bottom).offset(19)
        }
        
        alarmCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(23)
            $0.top.equalTo(timeSettingLabelStackView.snp.bottom).offset(28)
            $0.height.equalTo(convertByHeightRatio(133))
        }
        
        completeButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(50)
            $0.height.equalTo(convertByHeightRatio(60))
        }
        
        laterButton.snp.makeConstraints {
            $0.bottom.equalTo(completeButton.snp.top).offset(-19)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(19)
        }
    }

}
