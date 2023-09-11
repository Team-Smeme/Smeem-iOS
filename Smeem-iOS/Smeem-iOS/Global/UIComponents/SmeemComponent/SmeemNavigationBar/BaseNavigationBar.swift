//
//  BaseNavigationBar.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/09/04.
//

import UIKit

import SnapKit

// MARK: - BaseNavigationBar

class BaseNavigationBar: UIView {
    
    // MARK: - UI Properties
    
    private let leftButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .b1
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

    func setLeftButtonTitle(_ title: String) {
        leftButton.setTitle(title, for: .normal)
    }

    func setRightButtonTitle(_ title: String) {
        rightButton.setTitle(title, for: .normal)
    }

    func setLeftButtonImage(_ image: UIImage) {
        leftButton.setImage(image, for: .normal)
    }

    func setRightButtonImage(_ image: UIImage) {
        rightButton.setImage(image, for: .normal)
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setLeftButtonAction(target: Any?, action: Selector, for event: UIControl.Event) {
        leftButton.addTarget(target, action: action, for: event)
    }
    
    func setRightButtonAction(target: Any?, action: Selector, for event: UIControl.Event) {
        rightButton.addTarget(target, action: action, for: event)
    }
    
    func setButtonLayouts(leftMargin: CGFloat, rightMargin: CGFloat) {
            setLeftButtonLayout(leftMargin)
            setRightButtonLayout(rightMargin)
        }
    
    func setLeftButtonLayout(_ margin: CGFloat) {
        leftButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(margin)
        }
    }
    
    func setRightButtonLayout(_ margin: CGFloat) {
        rightButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(margin)
        }
    }
    
    func applyConfiguraton(_ configuration: NavigationBarConfiguration) {
        setLeftButtonTitle(configuration.leftButtonTitle ?? "")
        setRightButtonTitle(configuration.rightButtonTitle ?? "")
        setLeftButtonImage(configuration.leftButtonImage ?? UIImage())
        setRightButtonImage(configuration.rightButtonImage ?? UIImage())
        setTitle(configuration.title ?? "")
        
        switch configuration.layout {
        case .diary:
            setButtonLayouts(leftMargin: Constants.horizontalLeftButtonGap, rightMargin: Constants.horizontalRightButtonGap)
        case .detail:
            setButtonLayouts(leftMargin: Constants.horizontalArrowButtonGap, rightMargin: Constants.horizontalRightButtonGap)
        case .edit, .comment:
            setButtonLayouts(leftMargin: Constants.horizontalEditCommentButtonsGap, rightMargin: Constants.horizontalEditCommentButtonsGap)
        case .myPage:
            setButtonLayouts(leftMargin: Constants.horizontalArrowButtonGap, rightMargin: Constants.horizontalDotsIconButtonGap)
        default:
            break
        }
    }
}

//MARK: - Extensions

extension BaseNavigationBar {
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
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.verticalSteplabelGap)
        }
        
        rightButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
    }
}
