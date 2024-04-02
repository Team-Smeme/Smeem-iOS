//
//  BaseNavigationBar.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/09/04.
//

import UIKit
import Combine

import SnapKit

// MARK: - BaseNavigationBar

final class SmeemNavigationBar: UIView {
    
    // MARK: - Publishers
    
    weak var actionDelegate: NavigationBarActionDelegate?
    
    private (set) var leftButtonTapped = PassthroughSubject<Void, Never>()
    private (set) var rightButtonTapped = PassthroughSubject<Void, Never>()
    
    private var cancelBag = Set<AnyCancellable>()
    
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
        }
    }
    
    private func setRightButtonLayout(_ margin: CGFloat) {
        rightButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-margin)
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
        case .diaryLayout:
            setButtonLayouts(leftMargin: Constants.horizontalDiaryTextButtonGap.rawValue, rightMargin: Constants.horizontalDiaryTextButtonGap.rawValue)
        case .detailLayout:
            setButtonLayouts(leftMargin: Constants.horizontalArrowButtonGap.rawValue, rightMargin: Constants.horizontalDiaryTextButtonGap.rawValue)
        case .editLayout, .commentLayout:
            setButtonLayouts(leftMargin: Constants.horizontalEditCommentButtonsGap.rawValue, rightMargin: Constants.horizontalEditCommentButtonsGap.rawValue)
        case .myPageLayout:
            setButtonLayouts(leftMargin: Constants.horizontalArrowButtonGap.rawValue, rightMargin: Constants.horizontalDotsIconButtonGap.rawValue)
        default:
            break
        }
    }
    
    private func subscribeButtonEvents() {
        leftButton.tapPublisher.sink { [weak self] in
            self?.leftButtonTapped.send()
        }
        .store(in: &cancelBag)
        
        rightButton.tapPublisher.sink { [weak self] in
            self?.rightButtonTapped.send()
        }
        .store(in: &cancelBag)
    }
}

//MARK: - Extensions

extension SmeemNavigationBar {
    
    // TODO: 다 cgFoat
    enum Constants: CGFloat {
        case horizontalLeftButtonGap = 12
        case horizontalDiaryTextButtonGap, horizontalEditCommentButtonsGap = 18
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
    
    func updateRightButton(isValid: Bool) {
        self.rightButton.setTitleColor(isValid ? .point : .gray300, for: .normal)
    }
}
