//
//  BadgeBottomSheetViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2024/04/30.
//

import UIKit

import SnapKit

enum BadgeType {
    case welcome
    case diaryCount
    case dailyDiary
}

// MARK: - BadgeBottomSheet

final class BadgeBottomSheetViewController: BaseViewController {
    
    // MARK: - Properties
    
    
    // MARK: - UI Properties
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(Constant.Image.icnCancelBlack, for: .normal)
        return button
    }()
    
    private lazy var badgeImageView: UIImageView = UIImageView()
    
    private lazy var contentStackView: UIStackView = makeContentView()
    private lazy var headerLabel: UILabel = makeLabel(font: .h3, textColor: .smeemBlack)
    private lazy var bodyLabel: UILabel = makeLabel(font: .b3, textColor: .smeemBlack)
    
    private lazy var descriptionLabel: UILabel = makeLabel(font: .b3, textColor: .gray500)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
        
        badgeImageView.backgroundColor = .gray100
        headerLabel.text = "테스트"
        bodyLabel.text = "테슷흐"
        descriptionLabel.text = "test"
    }
}

// MARK: - Extensions

extension BadgeBottomSheetViewController {
    private func setLayout() {
        contentStackView.addArrangedSubviews(headerLabel, bodyLabel)
        view.addSubviews(dismissButton,
                         badgeImageView,
                         contentStackView,
                         descriptionLabel)
        
        dismissButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(8)
        }
        
        badgeImageView.snp.makeConstraints { make in
            make.top.equalTo(dismissButton.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.size.equalTo(120)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(badgeImageView.snp.bottom).offset(26)
            make.leading.trailing.equalToSuperview().inset(23)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(contentStackView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
    }
    
    private func makeContentView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }
    
    private func makeLabel(font: UIFont, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = textColor
        return label
    }
}
