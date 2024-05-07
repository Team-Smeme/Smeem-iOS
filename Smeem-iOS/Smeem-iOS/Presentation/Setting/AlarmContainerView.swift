//
//  AlarmContainerView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 5/7/24.
//

import UIKit

final class AlarmContainerView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "학습 알림"
        label.font = .s1
        label.textColor = .smeemBlack
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor.gray100.cgColor
        view.makeRoundCorner(cornerRadius: 6)
        return view
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.text = "트레이닝 푸시알림"
        label.font = .b4
        label.textColor = .smeemBlack
        return label
    }()
    
    private let alarmPushToggleButton: UISwitch = {
        let button = UISwitch()
        button.onTintColor = .point
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        addSubviews(titleLabel, containerView)
        containerView.addSubviews(detailLabel, alarmPushToggleButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(convertByHeightRatio(54))
        }
        
        detailLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(convertByWidthRatio(20))
        }
        
        alarmPushToggleButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-28)
            $0.width.equalTo(convertByWidthRatio(36))
        }
    }
}
