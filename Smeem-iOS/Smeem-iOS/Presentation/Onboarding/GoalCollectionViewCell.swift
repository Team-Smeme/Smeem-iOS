//
//  GoalCollectionViewCell.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/14.
//

import UIKit

import SnapKit

final class GoalCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "OnboardingGoalCollectionViewCell"
    
    // MARK: - Property
    
    // MARK: - UI Property
    
    private let checkButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .point
        return button
    }()
    
    private let goalLabel: UILabel = {
        let label = UILabel()
        label.font = .b3
        label.textColor = .gray600
        return label
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = .point
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - @objc
    
    // MARK: - Custom Method
    
    private func setLayout() {
        addSubviews(checkButton, goalLabel)
        
        checkButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
        
        goalLabel.snp.makeConstraints {
            $0.leading.equalTo(checkButton.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        }
    }
    
    func setData(_ text: String) {
        goalLabel.text = text
    }

}


