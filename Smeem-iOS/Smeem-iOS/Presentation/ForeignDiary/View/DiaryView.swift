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
    
    let configuration: DiaryViewConfiguration
    
//    var isTopicVisible: Bool = false {
//        if isTopicVisible {
//            addRandomTopicView()
//        } else {
//            removeRandomTopicView()
//        }
//    }
    
    // MARK: UI Properties
    
    private var navigationView: SmeemNavigationBar
    private (set) var inputTextView: SmeemTextView
    private (set) var bottomView: DiaryBottomView
    
    private var randomTopicView: RandomSubjectView?
    private var smeemToastView: SmeemToastView?
    
    // MARK: Life Cycle
    
    init(configuration: DiaryViewConfiguration,
         navigationBar: SmeemNavigationBar,
         inputTextView: SmeemTextView,
         bottomView: DiaryBottomView) {
        self.configuration = configuration
        self.navigationView = navigationBar
        self.inputTextView = inputTextView
        self.bottomView = bottomView
        
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
}

// MARK: - Helpers

extension DiaryView {
    
    func setNavigationBarDelegate(_ delegate: NavigationBarActionDelegate?) {
        self.navigationView.actionDelegate = delegate
    }
    
    func setInputText(_ text: String) {
        self.inputTextView.text = text
    }
    
//    func addRandomTopicView() {
//        if randomTopicView == nil {
//            randomTopicView = createRandomSubjectView()
//            addSubview(randomTopicView)
//        }
//    }
//
//    func removeRandomTopicView() {
//    }
    
    func updateRandomTopicView() {
//        if randomTopicEnabled {
//            addSubview(randomTopicView)
//            randomTopicView.snp.makeConstraints {
//                $0.top.equalTo(navigationView.snp.bottom).offset(convertByHeightRatio(16))
//                $0.leading.equalToSuperview()
//            }
//            randomSubjectButton.setImage(Constant.Image.btnRandomSubjectActive, for: .normal)
//        } else {
//            randomSubjectView.removeFromSuperview()
//            randomSubjectButton.setImage(Constant.Image.btnRandomSubjectInactive, for: .normal)
//        }
//    }
//
//    func updateInputTextViewConstraints() {
//        inputTextView.snp.remakeConstraints {
//            $0.top.equalTo(randomTopicEnabled ? randomSubjectView.snp.bottom : navigationView.snp.bottom)
//            $0.leading.trailing.equalToSuperview()
//            $0.bottom.equalTo(bottomView.snp.top)
//        }
    }
}
