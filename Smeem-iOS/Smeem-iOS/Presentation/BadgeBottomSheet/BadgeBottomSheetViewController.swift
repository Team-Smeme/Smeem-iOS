//
//  BadgeBottomSheetViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2024/04/30.
//

import UIKit

import SnapKit
import Kingfisher

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
    
    private lazy var badgeImageView: UIImageView = makeImage()
    
    private lazy var contentStackView: UIStackView = makeContentView()
    private lazy var headerLabel: UILabel = makeLabel(font: .h3, textColor: .smeemBlack)
    private lazy var bodyLabel: UILabel = makeLabel(font: .b3, textColor: .smeemBlack)
    
    private lazy var descriptionLabel: UILabel = makeLabel(font: .b3, textColor: .gray500)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
    }
    
    func setData(data: MySummaryBadgeAppData) {
        // 배지 획득시
        if data.hasBadge {
            let url = URL(string: data.imageUrl)
            badgeImageView.kf.setImage(with: url)
            
            switch data.type {
            case "EVENT":
                headerLabel.text = data.name
                bodyLabel.text = data.contentForBadgeOwner
                descriptionLabel.text = "100%의 사용자가 획득했어요."
            case "COUNTING":
                headerLabel.text = data.name
                bodyLabel.text = data.contentForBadgeOwner
                descriptionLabel.text = "\(data.badgeAcquisitionRatio)%의 사용자가 획득했어요."
            case "COMBO":
                headerLabel.text = data.name
                bodyLabel.text = data.contentForBadgeOwner
                descriptionLabel.text = "\(data.badgeAcquisitionRatio)%의 사용자가 획득했어요."
            case "EXPLORATION":
                headerLabel.text = data.name
                bodyLabel.text = data.contentForBadgeOwner
                descriptionLabel.text = "\(data.badgeAcquisitionRatio)%의 사용자가 획득했어요."
            default: break
            }
        } else {
            switch data.type {
            case "EVENT":
                headerLabel.text = data.name
                bodyLabel.text = data.contentForNonBadgeOwner
                descriptionLabel.text = "100%의 사용자가 획득했어요."
            case "COUNTING":
                headerLabel.text = data.name
                guard let number = data.remainingNumber else { return }
                bodyLabel.text = "일기를 \(number)번 더 작성해요"
                let attributedStr = NSMutableAttributedString(string: bodyLabel.text!)
                attributedStr.addAttribute(.foregroundColor, value: UIColor.point, range: (bodyLabel.text! as NSString).range(of: "\(number)"))
                bodyLabel.attributedText = attributedStr
                descriptionLabel.text = "\(data.badgeAcquisitionRatio)%의 사용자가 획득했어요."
            case "COMBO":
                headerLabel.text = data.name
                bodyLabel.text = data.contentForNonBadgeOwner
                descriptionLabel.text = "\(data.badgeAcquisitionRatio)%의 사용자가 획득했어요."
            case "EXPLORATION":
                headerLabel.text = data.name
                bodyLabel.text = data.contentForNonBadgeOwner
                descriptionLabel.text = "\(data.badgeAcquisitionRatio)%의 사용자가 획득했어요."
            default: break
                
            }
        }
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
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }
    
    private func makeLabel(font: UIFont, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = textColor
        return label
    }
    
    private func makeImage() -> UIImageView {
        let image = UIImageView()
        image.image = Constant.Image.btnLockBadge
        return image
    }
}
