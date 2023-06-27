//
//  DetailBadgeCollectionVIewCell.swift
//  Smeem-iOS
//
//  Created by JH on 2023/06/28.
//

import UIKit

final class DetailBadgeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Property
    
    static let identifier = "DetailBadgeCollectionViewCell"
    
    // MARK: - UI Property
    
    private let badgeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .point
        return imageView
    }()
    
    private let badgeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .c3
        label.backgroundColor = .smeemBlack
        label.textColor = .smeemBlack
        return label
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .brown
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - @objc
    // MARK: - Custom Method
    // MARK: - Layout
    
    private func setLayout() {
        addSubviews(badgeImage, badgeNameLabel)
        
        badgeImage.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        
        badgeNameLabel.snp.makeConstraints {
            $0.top.equalTo(badgeImage.snp.bottom).offset(2)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: - UITableView Delegate
}
