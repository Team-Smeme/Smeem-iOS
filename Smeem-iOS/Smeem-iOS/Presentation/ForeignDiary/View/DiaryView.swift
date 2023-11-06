//
//  ForeignDiaryView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/10/02.
//

import UIKit

import SnapKit

// MARK: - DiaryView

class DiaryView: BaseView {
    
    // MARK: Properties
    
    var randomTopicEnabled: Bool = false
    
    private (set) var configuration: DiaryViewConfiguration
    private let viewType: DiaryViewType
    
    // MARK: UI Properties
    
    private (set) var navigationView: SmeemNavigationBar
    private (set) var inputTextView: SmeemTextView
    private (set) var bottomView: DiaryBottomView
    
    var randomTopicView: RandomTopicView?
    private var smeemToastView: SmeemToastView?
    
    // MARK: Life Cycle
    
    init(configuration: DiaryViewConfiguration,
         viewType: DiaryViewType,
         navigationBar: SmeemNavigationBar,
         inputTextView: SmeemTextView,
         bottomView: DiaryBottomView,
         randomTopicView: RandomTopicView) {
        self.configuration = configuration
        self.viewType = viewType
        self.navigationView = navigationBar
        self.inputTextView = inputTextView
        self.bottomView = bottomView
        self.randomTopicView = randomTopicView
        
        super.init(frame: .zero)
        
        setLayout()
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
        
        inputTextView.snp.remakeConstraints { make in
            make.top.equalTo(layoutConfig.thickLine.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
    }
    
    func setTextViewHandlerDelegate(_ viewController: DiaryViewController) {
        inputTextView.handler?.delegate = viewController
    }
}

// MARK: - Helpers

extension DiaryView {
    
    func setNavigationBarDelegate(_ delegate: NavigationBarActionDelegate?) {
        self.navigationView.actionDelegate = delegate
    }
    
    func setInputText(_ text: String) {
        self.inputTextView.text = text
    }
    
    // MARK: RandomTopicView
    
    func updateRandomTopicView() {
        if randomTopicEnabled {
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
    
    func updateInputTextViewConstraints() {
        inputTextView.snp.remakeConstraints { make in
            guard let randomTopicView = randomTopicView else { return }
            
            make.top.equalTo(randomTopicEnabled ? randomTopicView.snp.bottom : navigationView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
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
