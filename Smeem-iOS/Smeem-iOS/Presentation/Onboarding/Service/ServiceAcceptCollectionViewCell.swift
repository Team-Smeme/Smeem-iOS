//
//  ServiceAcceptCollectionViewCell.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/17.
//

import UIKit

final class ServiceAcceptCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ServiceAcceptCollectionViewCell"
    
    var trainingClosure: ((IndexPath) -> Void)?
    
    var checkTotal = false {
        didSet {
            if checkTotal {
                serviceAcceptLabel.textColor = .black
                checkButton.setImage(Constant.Image.icnCheckActive, for: .normal)
            } else {
                serviceAcceptLabel.textColor = .gray600
                checkButton.setImage(Constant.Image.icnCheckInactive, for: .normal)
            }
        }
    }
    
    // MARK: - Property
    
    // MARK: - UI Property
    
    private let checkButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnCheckInactive, for: .normal)
        return button
    }()
    
    private let serviceAcceptLabel: UILabel = {
        let label = UILabel()
        label.font = .b4
        label.setTextWithLineHeight(lineHeight: 22)
        label.textColor = .smeemBlack
        return label
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnForward, for: .normal)
        button.addTarget(self, action: #selector(moreButtonDidTap), for: .touchUpInside)
        return button
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
    
    @objc func moreButtonDidTap() {
        trainingClosure?(getIndexPath()!)
    }
    
    // MARK: - Custom Method
    
    func setData(_ text: String) {
        serviceAcceptLabel.text = text
    }
    
    // MARK: - Layout
    
    private func setLayout() {
        addSubviews(checkButton, serviceAcceptLabel, moreButton)
        
        checkButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview()
            $0.height.width.equalTo(20)
        }
        
        serviceAcceptLabel.snp.makeConstraints {
            $0.leading.equalTo(checkButton.snp.trailing).offset(12)
            $0.top.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
