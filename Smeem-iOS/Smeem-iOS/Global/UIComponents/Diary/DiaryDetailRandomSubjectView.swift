//
//  DiaryDetailRandomSubjectView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/07.
//

import UIKit

import SnapKit

final class DiaryDetailRandomSubjectView: UIView {
    
    // MARK: - Property
    
    private var heightConstraint: Constraint?
    
    // MARK: - UI Property
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = .b1
        label.textColor = .point
        label.setTextWithLineHeight(lineHeight: 21)
        label.text = "Q."
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .b4
        label.textColor = .smeemBlack
        label.numberOfLines = 0
        label.setTextWithLineHeight(lineHeight: 22)
        label.text = "     " + "랜덤주제 한줄일 경우"
        return label
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setRandomSubjectViewUI()
        setRandomSubjectViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    private func updateViewHeightForNewContent() {
        let labelWidth = UIScreen.main.bounds.width - 36
        contentLabel.preferredMaxLayoutWidth = labelWidth
        contentLabel.setNeedsLayout()
        contentLabel.layoutIfNeeded()
        
        let contentLabelHeight: CGFloat = contentLabel.intrinsicContentSize.height
        
        if let heightConstraint = heightConstraint {
            let newHeight: CGFloat = contentLabelHeight <= 22 ? 62 : contentLabelHeight + 40
            heightConstraint.update(offset: newHeight)
        }
        
        print(contentLabelHeight)
    }
    
    func setData(contentText: String) {
        contentLabel.text = "     " + contentText
        contentLabel.setTextWithLineHeight(lineHeight: 22)
        updateViewHeightForNewContent()
    }
    
    
    // MARK: - Layout
    
    private func setRandomSubjectViewUI() {
        backgroundColor = .gray100
        
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
    }
    
    private func setRandomSubjectViewLayout() {
        
        snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.width.equalTo(convertByWidthRatio(375))
        }
        
        snp.makeConstraints {
            heightConstraint = $0.height.equalTo(128).constraint
        }
        
        addSubviews(questionLabel, contentLabel)
        
        questionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(convertByHeightRatio(20))
            $0.leading.equalToSuperview().offset(convertByWidthRatio(25))
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(questionLabel)
            $0.leading.equalTo(questionLabel)
        }
    }
}
