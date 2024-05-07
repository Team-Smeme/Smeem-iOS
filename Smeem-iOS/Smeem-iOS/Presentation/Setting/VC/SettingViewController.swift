//
//  SettingViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 5/7/24.
//

import UIKit

final class SettingViewController: BaseViewController {
    
    private let summaryScrollerView: UIScrollView = {
        let scrollerView = UIScrollView()
        scrollerView.showsVerticalScrollIndicator = false
        return scrollerView
    }()
    
    private let contentView = UIView()
    private let naviView = UIView()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnBack, for: .normal)
        return button
    }()
    
    private let summaryLabel: UILabel = {
        let label = UILabel()
        label.text = "설정"
        label.font = .s2
        label.textColor = .black
        return label
    }()
    
    private let settingButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnMore, for: .normal)
        return button
    }()
    
    private let planContainerView = PlanContainerView()
    private let nicknameContainerView = NicknameContainerView()
    private let languageContainerView = LanguageContainerView()
    private let alarmContainerView = AlarmContainerView()
    private let alarmCollectionView = AlarmCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
    }
    
    private func setLayout() {
        view.addSubviews(naviView, summaryScrollerView)
        naviView.addSubviews(backButton, summaryLabel, settingButton)
        summaryScrollerView.addSubview(contentView)
        contentView.addSubviews(planContainerView, nicknameContainerView,
                                languageContainerView, alarmContainerView, alarmCollectionView)
        
        naviView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(66)
        }
        
        summaryScrollerView.snp.makeConstraints {
            $0.top.equalTo(naviView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(summaryScrollerView.contentLayoutGuide)
            $0.width.equalTo(summaryScrollerView.frameLayoutGuide)
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
            $0.height.width.equalTo(40)
        }
        
        summaryLabel.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }
        
        settingButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.height.width.equalTo(40)
        }
        
        planContainerView.snp.makeConstraints {
            $0.top.equalTo(naviView.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(87)
        }
        
        nicknameContainerView.snp.makeConstraints {
            $0.top.equalTo(planContainerView.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(87)
        }
        
        languageContainerView.snp.makeConstraints {
            $0.top.equalTo(nicknameContainerView.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(87)
        }
        
        alarmContainerView.snp.makeConstraints {
            $0.top.equalTo(languageContainerView.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(87)
        }
        
        alarmCollectionView.snp.makeConstraints {
            $0.top.equalTo(alarmContainerView.snp.bottom).offset(convertByHeightRatio(10))
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().offset(-convertByHeightRatio(80))
            $0.height.equalTo(convertByHeightRatio(133))
        }
    }
}
