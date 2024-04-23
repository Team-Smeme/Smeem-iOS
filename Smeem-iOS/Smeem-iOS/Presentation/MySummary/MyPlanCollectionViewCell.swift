//
//  MyPlanCollectionViewCell.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 4/23/24.
//

import UIKit

final class MyPlanCollectionViewCell: UICollectionViewCell {
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = .c5
        label.textColor = .smeemWhite
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = self.layer.frame.size.width / 2
        self.backgroundColor = .point
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        addSubview(numberLabel)
        
        numberLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
