//
//  MyBadgeCollectionViewCell.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 4/24/24.
//

import UIKit

final class MyBadgeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Property
    
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
    
    private let badgeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
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
        badgeImage.kf.setImage(with: url)
        badgeNameLabel.text = data.name
    }
    
    // MARK: - Layout
    
    func setBadgeLayout() {
        addSubview(badgeStackView)
        badgeStackView.addArrangedSubviews(badgeImage, badgeNameLabel)
        
        badgeImage.snp.makeConstraints {
            $0.width.height.equalTo(66)
        }
        
        badgeStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func setLayout() {
        addSubview(badgeImage)
        
        badgeImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
