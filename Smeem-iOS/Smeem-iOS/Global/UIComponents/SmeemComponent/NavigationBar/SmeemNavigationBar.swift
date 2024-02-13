//
//  BaseNavigationBar.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/09/04.
//

import UIKit

import SnapKit

// MARK: - BaseNavigationBar

class SmeemNavigationBar: UIView {
    
    // MARK: - Properties
    
    weak var actionDelegate: NavigationBarActionDelegate?
    
    // MARK: - UI Properties
    
    private let leftButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .b4
        button.setTitleColor(.smeemBlack, for: .normal)
        return button
    }()
    
    private (set) var rightButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .b1
        button.setTitleColor(.gray300, for: .normal)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .s2
        label.textColor = .smeemBlack
        return label
    }()
    
    private let stepLabel: UILabel = {
        let label = UILabel()
        label.font = .c4
        label.textColor = .gray500
        return label
    }()
    
    // MARK: - Life Cycle
    
    init() {
        super.init(frame: .zero)
        
        setLayout()
        addButtonTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func setLeftButtonTitle(with title: String) {
        leftButton.setTitle(title, for: .normal)
    }
    
    func setRightButtonTitle(with title: String) {
        rightButton.setTitle(title, for: .normal)
    }
    
    func setLeftButtonImage(with image: UIImage) {
        leftButton.setImage(image, for: .normal)
    }
    
    func setRightButtonImage(with image: UIImage) {
        rightButton.setImage(image, for: .normal)
    }
    
    func setNavigationBarTitle(with title: String) {
        titleLabel.text = title
    }
    
    func setStepLabelTitle(with title: String) {
        stepLabel.text = title
    }
    
    func setLeftButtonAction(target: Any?, action: Selector, for event: UIControl.Event) {
        leftButton.addTarget(target, action: action, for: event)
    }
    
    func setRightButtonAction(target: Any?, action: Selector, for event: UIControl.Event) {
        rightButton.addTarget(target, action: action, for: event)
    }
    
    private func setButtonLayouts(leftMargin: CGFloat, rightMargin: CGFloat) {
        setLeftButtonLayout(leftMargin)
        setRightButtonLayout(rightMargin)
    }
    
    private func setLeftButtonLayout(_ margin: CGFloat) {
        leftButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(margin)
            make.height.width.equalTo(40)
        }
    }
    
    private func setRightButtonLayout(_ margin: CGFloat) {
        rightButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-margin)
            make.height.width.equalTo(40)
        }
    }
    
    func applyConfiguraton(_ configuration: NavigationBarConfiguration) {
        setLeftButtonTitle(with: configuration.leftButtonTitle ?? "")
        setRightButtonTitle(with: configuration.rightButtonTitle ?? "")
        setLeftButtonImage(with: configuration.leftButtonImage ?? UIImage())
        setRightButtonImage(with: configuration.rightButtonImage ?? UIImage())
        setNavigationBarTitle(with: configuration.title ?? "")
        setStepLabelTitle(with: configuration.stepLabelTitle ?? "")
        
        switch configuration.layout {
            /// TODO: 다이어리 step 1, ,2 분기
        case .diaryLayout:
            setButtonLayouts(leftMargin: 12, rightMargin: 18)
        case .detailLayout:
            setButtonLayouts(leftMargin: 12, rightMargin: 18)
        case .editLayout, .commentLayout:
            setButtonLayouts(leftMargin: 18, rightMargin: 18)
        case .myPageLayout:
            setButtonLayouts(leftMargin: 10, rightMargin: 16)
        default:
            break
        }
    }
    
    @objc func leftButtonTapped() {
        actionDelegate?.didTapLeftButton()
    }
    
    @objc func rightButtonTapped() {
        actionDelegate?.didTapRightButton()
    }
}

//MARK: - Extensions

extension SmeemNavigationBar {
    
    // TODO: 다 cgFoat
    enum Constants: CGFloat {
        case horizontalLeftButtonGap = 12
        case horizontalDiaryTextButtonGap, horizontalEditCommentButtonsGap = 50
        case horizontalArrowButtonGap = 20
        case horizontalDotsIconButtonGap = 16
        case horizontalMypageButtonGap = 26
        case verticalSteplabelGap = 3
    }
    
    private func setLayout() {
        addSubviews(leftButton, titleLabel, stepLabel, rightButton)
        
        leftButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        stepLabel.snp.makeConstraints { make in
            make.centerX.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.verticalSteplabelGap.rawValue)
        }
        
        rightButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
    }
    
    private func addButtonTargets() {
        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
    }
    
    func updateRightButton(isValid: Bool) {
        DispatchQueue.main.async {
//            self.rightButton.isEnabled = isValid
            self.rightButton.setTitleColor(isValid ? .point : .gray300, for: .normal)
        }
    }
}
