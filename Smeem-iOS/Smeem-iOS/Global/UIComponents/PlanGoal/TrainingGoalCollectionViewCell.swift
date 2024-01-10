//
//  PlanGoalCollectionViewCell.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/14.
//

import UIKit

import SnapKit

final class TrainingGoalCollectionViewCell: UICollectionViewCell {
    
    // MARK: UI Properties
    
    private let checkImageView: UIImageView = {
        let image = UIImageView()
        image.image = Constant.Image.icnCheckInactive
        return image
    }()
    
    private let goalLabel: UILabel = {
        let label = UILabel()
        label.font = .b3
        label.text = "전체 동의하기"
        label.textColor = .gray600
        return label
    }()
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Custom Method
    
    func setData(_ text: String) {
        goalLabel.text = text
    }
    
    func selctedCell() {
        goalLabel.font = .b1
        goalLabel.textColor = .point
        layer.borderColor = UIColor.point.cgColor
        checkImageView.image = Constant.Image.icnCheckActive
    }

    func desecltedCell() {
        goalLabel.font = .b3
        goalLabel.textColor = .gray600
        layer.borderColor = UIColor.gray100.cgColor
        checkImageView.image = Constant.Image.icnCheckInactive
    }
    
    // MARK: Layout
    
    private func setUI() {
        makeRoundCorner(cornerRadius: 6)
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.gray100.cgColor
    }
    
    private func setLayout() {
        addSubviews(checkImageView, goalLabel)
        
        checkImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
        
        goalLabel.snp.makeConstraints {
            $0.leading.equalTo(checkImageView.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        }
    }
}
