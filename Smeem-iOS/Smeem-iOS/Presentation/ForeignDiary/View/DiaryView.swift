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
    
    // MARK: UI Properties
    
    private var navigationView: SmeemNavigationBar
    private let inputTextView: SmeemTextView
    private let bottomView: DiaryBottomView
    
    private lazy var randomSubjectView = RandomSubjectView()
    private var smeemToastView: SmeemToastView?
    
    // MARK: Life Cycle
    
    init(configuration: DiaryViewConfiguration) {
        self.configuration = configuration
        
        self.navigationView = NavigationBarFactory.create(type: configuration.navigationBarType)
        self.inputTextView = SmeemTextView(type: configuration.textViewType, placeholderText: configuration.placeholderText)
        self.bottomView = DiaryBottomView(viewType: configuration.bottomViewType)
        
        super.init(frame: .zero)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions Layout

extension DiaryView {
    private func setLayout() {
        addSubviews(navigationView, inputTextView, bottomView)
        
        navigationView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(convertByHeightRatio(66))
        }
        
        inputTextView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        bottomView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(convertByHeightRatio(87))
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
