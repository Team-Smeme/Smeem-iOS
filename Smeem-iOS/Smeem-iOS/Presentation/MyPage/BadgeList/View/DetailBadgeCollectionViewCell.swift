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
        return imageView
    }()
    
    private let badgeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .c3
        label.textColor = .smeemBlack
        return label
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - @objc
    // MARK: - Custom Method
    
    func setdummyData(dummy: (name: String, image: String)) {
        badgeImage.image = UIImage(named: dummy.image)
        badgeNameLabel.text = dummy.name
    }
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
