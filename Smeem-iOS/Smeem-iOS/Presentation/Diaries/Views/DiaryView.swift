//
//  DiaryView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/10/02.
//

import UIKit

import SnapKit

// MARK: - DiaryView

class DiaryView: BaseView {
    
    // MARK: Properties
    private let viewType: DiaryViewType
    
    private (set) var configuration: DiaryViewConfiguration
    
    // MARK: UI Properties
    private (set) var navigationView: SmeemNavigationBar
    private (set) var inputTextView: SmeemTextView
    private (set) var bottomView: DiaryBottomView
    
    private (set) var randomTopicView: RandomTopicView?
    private (set) var smeemToastView: SmeemToastView?
    
    // MARK: - Life Cycle
    
    init(viewType: DiaryViewType,
         configuration: DiaryViewConfiguration,
         navigationBar: SmeemNavigationBar,
         inputTextView: SmeemTextView,
         bottomView: DiaryBottomView,
         randomTopicView: RandomTopicView) {
        
        self.viewType = viewType
        self.configuration = configuration
        self.navigationView = navigationBar
        self.inputTextView = inputTextView
        self.bottomView = bottomView
        self.randomTopicView = randomTopicView
        
        super.init(frame: .zero)
        
        setLayout()
    }
    
    override func layoutSubviews() {
        updateInputTextViewConstraintsForStepTwoView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        randomTopicView?.removeFromSuperview()
        smeemToastView?.removeFromSuperview()
    }
}

// MARK: - Layout Helpers

extension DiaryView {
    func setLayout() {
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
    
    func updateInputTextViewConstraintsForStepTwoView() {
        if viewType == .stepTwoKorean {
            inputTextView.snp.remakeConstraints { make in
                if let layoutConfig = configuration.layoutConfig {
                    make.top.equalTo(layoutConfig.thickLine.snp.bottom)
                } else {
                    make.top.equalTo(navigationView.snp.bottom)
                }
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(bottomView.snp.top)
            }
        }
    }
    
    // MARK: - RandomTopicView
    
    func updateRandomTopicView(isRandomTopicActive: Bool) {
        if isRandomTopicActive {
            guard let randomTopicView = randomTopicView else { return }

            addSubview(randomTopicView)
            randomTopicView.snp.makeConstraints { make in
                make.top.equalTo(navigationView.snp.bottom).offset(convertByHeightRatio(16))
                make.leading.equalToSuperview()
            }
        } else {
            randomTopicView?.removeFromSuperview()
        }
    }
    
    func updateInputTextViewConstraints(isRandomTopicActive: Bool) {
        inputTextView.snp.remakeConstraints { make in
            make.top.equalTo(isRandomTopicActive ? randomTopicView?.snp.bottom ?? 0 : navigationView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
    }
    
    func showToast(with toastType: ToastViewType) {
        let smeemToastView = SmeemToastView(type: toastType)
        smeemToastView.show(in: self, hasKeyboard: true)
        smeemToastView.hide(after: 3)
    }
}

// MARK: - Helpers

extension DiaryView {
    
    // MARK: - Settings
    
    func setNavigationBarDelegate(_ delegate: NavigationBarActionDelegate?) {
        navigationView.actionDelegate = delegate
    }
    
    func setTextViewHandlerDelegate(_ viewController: DiaryViewController) {
        inputTextView.handler?.delegate = viewController
    }
    
    func setHintButtonDelegate(_ viewController: StepTwoKoreanDiaryViewController) {
        bottomView.hintDelegate = viewController
    }
    
    func setInputText(_ text: String) {
        inputTextView.text = text
    }
}




// MARK: - Tutorial Components

//    private let tipLabel: UILabel = {
//        let label = UILabel()
//        label.text = "TIP"
//        label.font = .c3
//        label.textColor = .point
//        return label
//    }()
//
//    private lazy var cancelTipButton: UIButton = {
//        let button = UIButton()
//        button.setImage(Constant.Image.icnCancelGrey, for: .normal)
//        return button
//    }()
