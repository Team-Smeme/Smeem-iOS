//
//  RandomSubjectView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/05/03.
//

/**
 1. 사용할 VC에서 RandomSubjectView 생성
 let randomSubjectView = RandomSubjectView()
 
 2. view에 addSubView 후 y축 레이아웃 값만 입력해서 사용
 **/


import UIKit

import SnapKit

protocol RandomTopicRefreshDelegate: AnyObject {
    func refreshButtonTapped(completion: @escaping (String?) -> Void)
}

// MARK: - RandomTopicView

final class RandomTopicView: UIView {
    
    // MARK: - Properties
    
    weak var randomTopicRefreshDelegate: RandomTopicRefreshDelegate?
    
    private var heightConstraint: Constraint?
    
    // MARK: - UI Properties
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = .b1
        label.textColor = .point
        label.text = "Q."
        label.setTextWithLineHeight(lineHeight: 21)
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .b4
        label.textColor = .smeemBlack
        label.numberOfLines = 0
        label.text = "     " + "오늘부터 딱 일주일 후! 설레는 크리스마스네요.\n일주일 전부터 세워보는 나의 크리스마스 계획은?"
        label.setTextWithLineHeight(lineHeight: 22)
        return label
    }()
    
    private lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnRefresh, for: .normal)
        button.addTarget(self, action: #selector(refreshButtonDidTap), for: .touchUpInside)
        return button
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
}

// MARK: - Extensions

extension RandomTopicView {
    
    // MARK: - Layout Helpers
    
    private func setRandomSubjectViewUI() {
        backgroundColor = .gray100
        
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byWordWrapping
    }
    
    private func setRandomSubjectViewLayout() {
        
        snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.width.equalTo(convertByWidthRatio(375))
        }
        
        snp.makeConstraints { make in
                heightConstraint = make.height.equalTo(110).constraint
            }
        
        addSubviews(questionLabel, contentLabel, refreshButton)
        
        questionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(convertByHeightRatio(20))
            make.leading.equalToSuperview().offset(convertByWidthRatio(18))
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(questionLabel)
            make.leading.equalTo(questionLabel)
            make.trailing.equalToSuperview().inset(convertByWidthRatio(42))
        }
        
        refreshButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(convertByHeightRatio(-20))
            make.trailing.equalToSuperview().offset(convertByWidthRatio(-18))
        }
    }
    
    private func updateViewHeightForNewContent() {
        
        let contentLabelHeight: CGFloat = contentLabel.intrinsicContentSize.height
        
        if let heightConstraint = heightConstraint {
            let newHeight: CGFloat = contentLabelHeight <= 22 ? 88 : contentLabelHeight + 66
            heightConstraint.update(offset: newHeight)
        }
    }
    
    // MARK: - @objc
    
    @objc func refreshButtonDidTap() {
        randomTopicRefreshDelegate?.refreshButtonTapped { [weak self] newContentText in
            DispatchQueue.main.async {
                self?.setData(contentText: newContentText ?? "")
            }
        }
    }
}

// MARK: - Network

extension RandomTopicView {
    func setData(contentText: String) {
        contentLabel.text = "     " + contentText
        contentLabel.setTextWithLineHeight(lineHeight: 22)
        updateViewHeightForNewContent()
    }
}
