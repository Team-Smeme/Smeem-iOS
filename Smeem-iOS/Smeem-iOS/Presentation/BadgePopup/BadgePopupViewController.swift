//
//  BadgePopupViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/06/29.
//

import UIKit

import SnapKit

final class BadgePopupViewController: UIViewController {
    
    // MARK: - Property
    
    // MARK: - UI Property
    
    private let popupView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.makeRoundCorner(cornerRadius: 10)
        return view
    }()
    
    private let badgeImage = UIImageView()
    
    private let badgeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .s3
        label.textColor = .black
        return label
    }()
    
    private let badgeDetailLabel: UILabel = {
        let label = UILabel()
        label.font = .c3
        label.textColor = .gray600
        label.numberOfLines = 2
        return label
    }()
    
    private let cancleButton: SmeemButton = {
        let button = SmeemButton()
        button.smeemButtonType = .enabled
        button.backgroundColor = .gray100
        button.titleLabel?.font = .c2
        button.setTitleColor(.gray600, for: .normal)
        button.setTitle("닫기", for: .normal)
        return button
    }()
    
    private let presentBadgeListButton: SmeemButton = {
        let button = SmeemButton()
        button.smeemButtonType = .enabled
        button.titleLabel?.font = .c2
        button.setTitle("배지 모두보기", for: .normal)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        setLayout()
    }
    
    // MARK: - @objc
    
    // MARK: - Custom Method
    
    // MARK: - Layout
    
    private func setBackgroundColor() {
        view.backgroundColor = .gray300
    }
    
    private func setLayout() {
        view.addSubview(popupView)
        popupView.addSubviews(badgeImage, badgeTitleLabel, badgeDetailLabel, cancleButton, presentBadgeListButton)
        
        popupView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(convertByHeightRatio(201))
            $0.centerX.equalToSuperview()
            $0.width.equalTo(298)
            $0.height.equalTo(390)
        }
        
        badgeImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(convertByHeightRatio(28))
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(convertByHeightRatio(164))
        }
        
        badgeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(badgeImage.snp.bottom).offset(convertByHeightRatio(12))
            $0.centerY.equalToSuperview()
        }
        
        badgeDetailLabel.snp.makeConstraints {
            $0.top.equalTo(badgeTitleLabel.snp.bottom).offset(convertByHeightRatio(33))
            $0.centerY.equalToSuperview()
        }
        
        cancleButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.trailing.equalTo(presentBadgeListButton.snp.leading).offset(-8)
            $0.bottom.equalToSuperview().inset(10)
            $0.width.equalTo(135)
            $0.height.equalTo(50)
        }
        
        presentBadgeListButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(50)
        }
    }

}
