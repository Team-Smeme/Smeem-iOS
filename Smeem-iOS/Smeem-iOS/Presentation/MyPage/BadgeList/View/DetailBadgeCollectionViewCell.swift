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
    
    private let badgeImage = UIImageView()
    
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
    
    // MARK: - Custom Method
    
    func setBadgeData(data: (name: String, image: String)) {
        let url = URL(string: data.image)
        Task {
            do {
                try await badgeImage.loadImage(data.image)
            } catch let error {
                print("안녕!!!", error.localizedDescription)
            }
        }
//        badgeImage.kf.setImage(with: url)
        badgeNameLabel.text = data.name
    }
    // MARK: - Layout
    
    private func setLayout() {
        addSubviews(badgeImage, badgeNameLabel)
        
        badgeImage.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        
        badgeNameLabel.snp.makeConstraints {
            $0.top.equalTo(badgeImage.snp.bottom).offset(convertByHeightRatio(8))
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: - UITableView Delegate
}
