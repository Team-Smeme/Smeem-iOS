//
//  ServiceAcceptCollectionViewCell.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/17.
//

import UIKit

final class ServiceAcceptCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ServiceAcceptCollectionViewCell"
    
    // MARK: - Property
    
    // MARK: - UI Property
    
    private let checkButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .point
        return button
    }()
    
    private let serviceAcceptLabel: UILabel = {
        let label = UILabel()
        label.font = .b4
        label.setTextWithLineHeight(lineHeight: 22)
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
    
    func setData(_ text: String) {
        serviceAcceptLabel.text = text
    }
    
    // MARK: - Layout
    
    private func setLayout() {
        addSubviews(checkButton, serviceAcceptLabel)
        
        checkButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview()
            $0.height.width.equalTo(20)
        }
        
        serviceAcceptLabel.snp.makeConstraints {
            $0.leading.equalTo(checkButton.snp.trailing).offset(12)
            $0.top.equalToSuperview()
        }
    }

}
