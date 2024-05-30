//
//  LockBadgeCollectionViewCell.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 5/20/24.
//

import UIKit

final class LockBadgeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI Property
    
    private let badgeLockImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constant.Image.btnLockBadge
        return imageView
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    // MARK: - Layout
    
    func setLayout() {
        addSubview(badgeLockImage)
        
        badgeLockImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
