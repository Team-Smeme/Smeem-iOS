//
//  DiaryBottomView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/09/29.
//

import UIKit

import SnapKit

protocol RandomTopicActionDelegate: AnyObject {
    func didTapRandomTopicButton()
}

protocol HintActionDelegate: AnyObject {
    func didTapHintButton()
}

enum DiaryBottomViewType {
    case standard
    case withHint
}

// MARK: - DiaryBottomView

final class DiaryBottomView: UIView {
    
    // MARK: Properties
    
    let viewType: DiaryBottomViewType
    
    weak var randomTopicDelegate: RandomTopicActionDelegate?
    weak var hintDelegate: HintActionDelegate?
    
    // MARK: UI Properties
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    let thinLine = SeparationLine(height: .thin)
    
    lazy var randomTopicButton = UIButton()
    
    private lazy var dismissButton: UIButton? = {
        let button = UIButton()
        //        button.addTarget(self, action: #selector(dismissButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    //    lazy var randomSubjectToolTip: UIImageView? = {
    //        let image = UIImageView()
    //        image.image = Constant.Image.icnToolTip
    //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(randomSubjectToolTipDidTap))
    //        image.addGestureRecognizer(tapGesture)
    //        image.isUserInteractionEnabled = true
    //        return image
    //    }()
    
    lazy var hintButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.btnTranslateInactive, for: .normal)
        return button
    }()
    
    // MARK: Life Cycle
    
    init(frame: CGRect = .zero, viewType: DiaryBottomViewType) {
        self.viewType = viewType
        super.init(frame: frame)
        
        setupUI()
        setupLayout()
        addButtonTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension DiaryBottomView {
    
    // MARK: - Settings
    private func addButtonTargets() {
        randomTopicButton.addTarget(self, action: #selector(randomTopicButtonTapped), for: .touchUpInside)
        hintButton.addTarget(self, action: #selector(hintButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Layout Helpers
    
    private func setupUI() {
        setBackgroundColor()
        setRandomTopicImage()
    }
    
    // 재사용 가능할지도..?
    private func setBackgroundColor() {
        self.backgroundColor = .gray100
    }
    
    private func setRandomTopicImage() {
        switch viewType {
        case .standard:
            randomTopicButton.setImage(Constant.Image.btnRandomSubjectInactive, for: .normal)
        case .withHint:
            randomTopicButton.setImage(Constant.Image.btnRandomSubjectEnabled, for: .normal)
        }
    }
    
    private func setupLayout() {
        addSubviews(thinLine, randomTopicButton)
        
        thinLine.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.top)
            make.centerX.equalToSuperview()
        }
        
        randomTopicButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(convertByHeightRatio(17 - 5))
            make.trailing.equalToSuperview().offset(convertByWidthRatio(-18 + 5))
            make.width.equalTo(convertByWidthRatio(78 + 10))
            make.height.equalTo(convertByHeightRatio(19 + 10))
        }
        
        if viewType == .withHint {
            addSubview(hintButton)
            hintButton.snp.makeConstraints { make in
                make.centerY.equalTo(randomTopicButton)
                make.leading.equalToSuperview().offset(18 - 10)
                make.width.equalTo(convertByWidthRatio(92 + 10))
                make.height.equalTo(convertByHeightRatio(29 + 10))
            }
        }
    }
    
    // MARK: - Action Helpers
    
    @objc func randomTopicButtonTapped() {
        randomTopicDelegate?.didTapRandomTopicButton()
    }
    
    @objc func hintButtonTapped() {
        hintDelegate?.didTapHintButton()
    }
    
    func updateRandomTopicButtonImage(_ isEnabled: Bool) {
        randomTopicButton.setImage(isEnabled ? Constant.Image.btnRandomSubjectActive : Constant.Image.btnRandomSubjectInactive, for: .normal)
    }
    
    func updateHintButtonImage(_ isHintShowed: Bool) {
        hintButton.setImage(isHintShowed ? Constant.Image.btnTranslateActive : Constant.Image.btnTranslateInactive, for: .normal)
    }
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
