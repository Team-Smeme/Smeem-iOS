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

protocol RandomSubjectViewDelegate: AnyObject {
    func refreshButtonTapped(completion: @escaping (String?) -> Void)
}

final class RandomSubjectView: UIView {
    
    // MARK: - Property
    
    weak var delegate: RandomSubjectViewDelegate?
    
    private var heightConstraint: Constraint?
    
    // MARK: - UI Property
    
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
    
    // MARK: - @objc
    
    @objc func refreshButtonDidTap() {
        delegate?.refreshButtonTapped { [weak self] newContentText in
            DispatchQueue.main.async {
                self?.setData(contentText: newContentText ?? "")
            }
        }
    }
    
    // MARK: - Custom Method

    func setData(contentText: String) {
        contentLabel.text = "     " + contentText
        contentLabel.setTextWithLineHeight(lineHeight: 22)
        updateViewHeightForNewContent()
    }

    private func updateViewHeightForNewContent() {
        let labelWidth = UIScreen.main.bounds.width - 36
        contentLabel.preferredMaxLayoutWidth = labelWidth
        contentLabel.setNeedsLayout()
        contentLabel.layoutIfNeeded()
        
        let contentLabelHeight: CGFloat = contentLabel.intrinsicContentSize.height
        
        if let heightConstraint = heightConstraint {
            let newHeight: CGFloat = contentLabelHeight <= 22 ? 88 : contentLabelHeight + 66
            heightConstraint.update(offset: newHeight)
        }
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
                heightConstraint = $0.height.equalTo(110).constraint
            }
        
        addSubviews(questionLabel, contentLabel, refreshButton)
        
        questionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(convertByHeightRatio(20))
            $0.leading.equalToSuperview().offset(convertByWidthRatio(18))
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(questionLabel)
            $0.leading.equalTo(questionLabel)
        }
        
        refreshButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(convertByHeightRatio(-20))
            $0.trailing.equalToSuperview().offset(convertByWidthRatio(-18))
        }
    }
}
