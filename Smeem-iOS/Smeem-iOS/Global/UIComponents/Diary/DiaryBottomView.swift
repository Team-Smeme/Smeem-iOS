//
//  DiaryBottomView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/09/29.
//

import UIKit

import SnapKit

enum DiaryBottomViewType {
    case standard
    case withHint
}

// MARK: - DiaryBottomView

final class DiaryBottomView: UIView {
    
    // MARK: Properties
    
    let viewType: DiaryBottomViewType
    
    // MARK: UI Properties
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    let thinLine = SeparationLine(height: .thin)
    
    lazy var randomSubjectButton: UIButton = {
        let button = UIButton()
        //        button.addTarget(self, action: #selector(randomTopicButtonDidTap), for: .touchUpInside)
        button.setImage(Constant.Image.btnRandomSubjectInactive, for: .normal)
        return button
    }()
    
    private lazy var dismissButton: UIButton? = {
        let button = UIButton()
        //        button.addTarget(self, action: #selector(dismissButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    lazy var randomSubjectToolTip: UIImageView? = {
        let image = UIImageView()
        image.image = Constant.Image.icnToolTip
        //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(randomSubjectToolTipDidTap))
        //        image.addGestureRecognizer(tapGesture)
        image.isUserInteractionEnabled = true
        return image
    }()
    
    private lazy var hintButton: UIButton = {
        let button = UIButton()
        //        button.backgroundColor = .clear
        //        button.addTarget(self, action: #selector(hintButtondidTap), for: .touchUpInside)
        button.setImage(Constant.Image.btnTranslateInactive, for: .normal)
        return button
    }()
    
    // MARK: Life Cycle
    
    init(frame: CGRect = .zero, viewType: DiaryBottomViewType) {
        self.viewType = viewType
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension DiaryBottomView {
    
    // MARK: - Layout Helpers
    
    private func setUI() {
        self.backgroundColor = .gray100
    }
    
    private func setLayout() {
        addSubviews(thinLine, randomSubjectButton)
        
        thinLine.snp.makeConstraints {
            $0.bottom.equalTo(self.snp.top)
            $0.centerX.equalToSuperview()
        }
        
        randomSubjectButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(convertByHeightRatio(17 - 5))
            $0.trailing.equalToSuperview().offset(convertByWidthRatio(-18 + 5))
            $0.width.equalTo(convertByWidthRatio(78 + 10))
            $0.height.equalTo(convertByHeightRatio(19 + 10))
        }
        
        if viewType == .withHint {
            addSubview(hintButton)
            hintButton.snp.makeConstraints {
                $0.centerY.equalTo(randomSubjectButton)
                $0.leading.equalToSuperview().offset(18 - 10)
                $0.width.equalTo(convertByWidthRatio(92 + 10))
                $0.height.equalTo(convertByHeightRatio(29 + 10))
            }
        }
    }
    
    // MARK: - Action Helpers
    
//    @objc func randomTopicButtonDidTap() {
//        if !UserDefaultsManager.randomSubjectToolTip {
//            UserDefaultsManager.randomSubjectToolTip = true
//            randomSubjectToolTip?.isHidden = true
//        }
//
//        setRandomTopicButtonToggle()
//
//        if !isTopicCalled {
//            randomSubjectWithAPI()
//            randomSubjectButton.setImage(Constant.Image.btnRandomSubjectActive, for: .normal)
//            isTopicCalled = true
//        } else {
//            isTopicCalled = false
//            topicID = nil
//        }
//        randomSubjectView.setData(contentText: topicContent)
//    }
}


//    private func checkTooltip() {
//        let randomSubjectToolTipe = UserDefaultsManager.randomSubjectToolTip
//
//        if !randomSubjectToolTipe {
//
//            view.addSubview(randomSubjectToolTip ?? UIImageView())
//
//            randomSubjectToolTip?.snp.makeConstraints {
//                $0.width.equalTo(convertByWidthRatio(180))
//                $0.height.equalTo(convertByHeightRatio(48))
//                $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(constraintByNotch(-37, -42))
//                $0.trailing.equalToSuperview().inset(convertByHeightRatio(18))
//            }
//        } else {
//            randomSubjectToolTip = nil
//        }
//    }
