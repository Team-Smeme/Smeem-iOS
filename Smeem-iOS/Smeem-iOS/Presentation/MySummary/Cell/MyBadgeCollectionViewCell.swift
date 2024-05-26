//
//  MyBadgeCollectionViewCell.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 4/24/24.
//

import UIKit

final class MyBadgeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Property
    
    private let badgeLockImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constant.Image.btnLockBadge
        return imageView
    }()
    
    private let badgeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constant.Image.btnLockBadge
        return imageView
    }()
    
    private let badgeNameLabel: UILabel = {
        let label = UILabel()
        label.text = "잠만"
        label.font = .c6
        label.textColor = .smeemBlack
        return label
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .smeemWhite
        self.makeRoundCorner(cornerRadius: 10)
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.gray100.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    func setBadgeData(data: (name: String, image: String)) {
        let url = URL(string: data.image)
        badgeImage.kf.setImage(with: url)
        badgeNameLabel.text = data.name
    }
    
    // MARK: - Layout
    
    func setLayout() {
        addSubview(badgeImage)
        
        badgeImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setBadgeLayout() {
        addSubviews(badgeImage, badgeNameLabel)
        
        let superViewWidth = self.frame.width-42
        
        badgeImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(convertByWidthRatio(11))
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(superViewWidth)
        }
        
        badgeNameLabel.snp.makeConstraints {
            $0.top.equalTo(badgeImage.snp.bottom).offset(3)
            $0.centerX.equalTo(badgeImage)
        }
    }
    
    func setBadgeHidden() {
        badgeImage.isHidden = true
        badgeNameLabel.isHidden = true
    }
}
