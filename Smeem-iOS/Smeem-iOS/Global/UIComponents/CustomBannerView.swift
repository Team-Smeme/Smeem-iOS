//
//  CustomBannerView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2024/07/09.
//

import UIKit

import SnapKit

final class CustomBannerView: BaseView {
    
    private let cancelAction = UIAction { _ in
        
    }
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .s1
        label.textColor = .smeemBlack
        label.text = "스밈에 의견 남기고 선물 받아가세요!"
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .c3
        label.textColor = .smeemBlack
        label.text = "자유롭게 의견을 나눠주실 분들을 모시고 있어요."
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(primaryAction: cancelAction)
        button.setImage(Constant.Image.icnCancelGrey, for: .normal)
        button.tintColor = .gray200
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUI() {
        backgroundColor = .gray100
        layer.cornerRadius = 10
    }
}

extension CustomBannerView {
    private func setLayout() {
        addSubviews(headerLabel, bodyLabel, closeButton)
        
        headerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(22)
            make.leading.equalToSuperview().offset(18)
        }
        
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(4)
            make.leading.equalTo(headerLabel)
        }
        
        closeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.size.equalTo(40)
        }
    }
}
