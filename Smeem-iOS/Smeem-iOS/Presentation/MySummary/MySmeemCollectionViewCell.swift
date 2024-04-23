//
//  MySmeemCollectionViewCell.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 4/23/24.
//

import UIKit

final class MySmeemCollectionViewCell: UICollectionViewCell {
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = .s2
        label.textColor = .smeemBlack
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .c2
        label.textColor = .smeemBlack
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
        setBackgroundColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNumberData(number: String) {
        numberLabel.text = number
    }
    
    func setTextData(text: String) {
        descriptionLabel.text = text
    }
    
    private func setLayout() {
        addSubviews(numberLabel, descriptionLabel)
        
        numberLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(numberLabel.snp.bottom).offset(6)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func setBackgroundColor() {
        backgroundColor = .white
    }
    
}
