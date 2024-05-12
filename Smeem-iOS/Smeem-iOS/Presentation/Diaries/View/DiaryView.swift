//
//  DiaryView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/10/02.
//

import Combine
import UIKit
import Combine

import SnapKit

// MARK: - ToolTipDelegate

protocol ToolTipDelegate: AnyObject {
    func didTapToolTipButton()
}

// MARK: - DiaryView

final class DiaryView: BaseView {
    
    // MARK: - Subjects
    
    private (set) var viewTypeSubject = CurrentValueSubject<DiaryViewType?, Never>(.none)
    private (set) var toolTipTapped = PassthroughSubject<Void, Never>()
    
    private var cancelBag = Set<AnyCancellable>()
    
    // MARK: - Properties
    
    private (set) var viewType: DiaryViewType
    private (set) var configuration: DiaryViewConfiguration
    
    var leftButtonPublisher: AnyPublisher<Void, Never> {
        navigationView.leftButtonTapped.eraseToAnyPublisher()
    }
    
    var rightButtonPublisher: AnyPublisher<Void, Never> {
        navigationView.rightButtonTapped.eraseToAnyPublisher()
    }
    
    weak var toolTipDelegate: ToolTipDelegate?
    
    // MARK: - UI Properties
    
    private (set) var navigationView: SmeemNavigationBar
    private (set) var inputTextView: SmeemTextView
    private (set) var bottomView: DiaryBottomView
    
    private (set) var randomTopicView: RandomTopicView
    private (set) var toastView: SmeemToastView
    
    private lazy var toolTip: UIImageView = {
        let image = UIImageView()
        image.image = Constant.Image.icnToolTip
        image.isUserInteractionEnabled = true
        return image
    }()
    
    // MARK: - Life Cycle
    
    init(viewType: DiaryViewType,
         configuration: DiaryViewConfiguration,
         navigationBar: SmeemNavigationBar,
         inputTextView: SmeemTextView,
         bottomView: DiaryBottomView,
         randomTopicView: RandomTopicView,
         toastView: SmeemToastView) {
        
        self.viewType = viewType
        self.configuration = configuration
        self.navigationView = navigationBar
        self.inputTextView = inputTextView
        self.bottomView = bottomView
        self.randomTopicView = randomTopicView
        self.toastView = toastView
        
        super.init(frame: .zero)
        
        setLayout()
        subscribeToolTipView()
        viewTypeSubject.send(viewType)
    }
    
    override func layoutSubviews() {
        updateInputTextViewConstraintsForStepTwoView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        randomTopicView.removeFromSuperview()
        toastView.removeFromSuperview()
        toolTip.removeFromSuperview()
    }
}

// MARK: - Layout Helpers

extension DiaryView {
    private func setLayout() {
        addSubviews(navigationView, inputTextView, bottomView)
        
        navigationView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(convertByHeightRatio(Constant.Layout.navigationBarHeight))
        }
        
        inputTextView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        bottomView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(convertByHeightRatio(Constant.Layout.bottomViewHeight))
        }
        
        guard let layoutConfig = configuration.layoutConfig else  { return }
        
        addSubviews(layoutConfig.hintTextView, layoutConfig.thickLine)
        
        layoutConfig.hintTextView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(convertByHeightRatio(120))
        }
        
        layoutConfig.thickLine.snp.makeConstraints { make in
            make.top.equalTo(layoutConfig.hintTextView.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - Action Helpers

extension DiaryView {
    
    // MARK: - RandomTopicView
    
    func setInputText(_ text: String) {
        inputTextView.text = text
    }
    
    func updateRandomTopicView(isRandomTopicActive: Bool) {
        if isRandomTopicActive {
            addSubview(randomTopicView)
            randomTopicView.snp.makeConstraints { make in
                make.top.equalTo(navigationView.snp.bottom).offset(convertByHeightRatio(16))
                make.leading.equalToSuperview()
            }
        } else {
            randomTopicView.removeFromSuperview()
        }
    }
    
    func updateInputTextViewConstraints(isRandomTopicActive: Bool) {
        inputTextView.snp.remakeConstraints { make in
            make.top.equalTo(isRandomTopicActive ? randomTopicView.snp.bottom : navigationView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
    }
    
    func updateInputTextViewConstraintsForStepTwoView() {
        if viewType == .stepTwoKorean {
            inputTextView.snp.remakeConstraints { make in
                make.top.equalTo(configuration.layoutConfig?.thickLine.snp.bottom ?? navigationView.snp.bottom)
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(bottomView.snp.top)
            }
        }
    }
    
    // MARK: - ToastView
    
    func showToast(with toastType: ToastViewType) {
        toastView.show(in: self, hasKeyboard: true)
        toastView.hide(after: 3)
    }
}

// MARK: - ToolTip

extension DiaryView {
    func setToolTip() {
        addSubview(toolTip)
        
        toolTip.snp.makeConstraints { make in
            make.width.equalTo(convertByWidthRatio(180))
            make.height.equalTo(convertByHeightRatio(48))
            make.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(constraintByNotch(-37, -42))
            make.trailing.equalToSuperview().inset(convertByHeightRatio(18))
        }
    }
    
    private func subscribeToolTipView() {
        toolTip.gesturePublisher
            .sink { [weak self] _ in
                self?.toolTipTapped.send()
            }
            .store(in: &cancelBag)
    }
    
    func removeToolTip() {
        toolTip.removeFromSuperview()
    }
}
