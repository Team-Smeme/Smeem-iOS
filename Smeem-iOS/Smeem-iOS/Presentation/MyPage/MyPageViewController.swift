//
//  MyPageViewController.swift
//  Smeem-iOS
//
//  Created by 임주민 on 2023/06/27.
//

import UIKit

import SnapKit

final class MyPageViewController: UIViewController {
    
    // MARK: - Property
    
    private var userInfo = MyPageInfo(username: "", target: "", way: "", detail: "", targetLang: "", hasPushAlarm: true, trainingTime: TrainingTime(day: "", hour: 0, minute: 0), badges: [])  
    
    // MARK: - UI Property
    
    private let headerContainerView = UIView()
    private let contentView = UIView()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnBack, for: .normal)
        button.addTarget(self, action: #selector(backButtonDidTap(_:)), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "마이 페이지"
        label.font = .s2
        label.textColor = .smeemBlack
        return label
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnMoreMono, for: .normal)
        button.addTarget(self, action: #selector(moreButtonDidTap(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let nickNameLabel = UILabel()
        nickNameLabel.font = .h3
        nickNameLabel.textColor = .smeemBlack
        return nickNameLabel
    }()
    
    private lazy var editButton: UIButton = {
        let editButton = UIButton()
        editButton.setImage(Constant.Image.icnPencil, for: .normal)
        editButton.addTarget(self, action: #selector(editButtonDidTap(_:)), for: .touchUpInside)
        return editButton
    }()
    
    private let howLearningView: HowLearningView = {
        let view = HowLearningView()
        view.buttontype = .logo
        return view
    }()
    
    private let badgeLabel: UILabel = {
        let badgeLabel = UILabel()
        badgeLabel.text = "내 배지"
        badgeLabel.font = .s1
        badgeLabel.textColor = .smeemBlack
        return badgeLabel
    }()
    
    private let badgeContainer: UIView = {
        let badgeContainer = UIView()
        badgeContainer.backgroundColor = .clear
        badgeContainer.layer.borderWidth = 1.5
        badgeContainer.layer.borderColor = UIColor.gray100.cgColor
        badgeContainer.makeRoundCorner(cornerRadius: 6)
        return badgeContainer
    }()
    
    private let badgeImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .gray600
        return image
    }()
    
    private let badgeNameLabel: UILabel = {
        let badgeNameLabel = UILabel()
        badgeNameLabel.text = "웰컴 배지"
        badgeNameLabel.font = .b1
        badgeNameLabel.textColor = .smeemBlack
        return badgeNameLabel
    }()
    
    private let badgeSummaryLabel: UILabel = {
        let badgeSummaryLabel = UILabel()
        badgeSummaryLabel.text = "축하해요! 웰컴 배지를 획득했어요!"
        badgeSummaryLabel.font = .b4
        badgeSummaryLabel.textColor = .gray600
        return badgeSummaryLabel
    }()
    
    private let languageLabel: UILabel = {
        let languageLabel = UILabel()
        languageLabel.text = "학습 언어"
        languageLabel.font = .s1
        languageLabel.textColor = .smeemBlack
        return languageLabel
    }()
    
    private let languageContainer: UIView = {
        let languageContainer = UIView()
        languageContainer.backgroundColor = .clear
        languageContainer.layer.borderWidth = 1.5
        languageContainer.layer.borderColor = UIColor.gray100.cgColor
        languageContainer.makeRoundCorner(cornerRadius: 6)
        return languageContainer
    }()
    
    private let languageLabelEnglish: UILabel = {
        let languageLabel = UILabel()
        languageLabel.text = "English"
        languageLabel.font = .b4
        languageLabel.textColor = .smeemBlack
        return languageLabel
    }()
    
    private let languageCheckButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnCheck, for: .normal)
        return button
    }()
    
    private let alarmLabel: UILabel = {
        let alarmLabel = UILabel()
        alarmLabel.text = "학습 알림"
        alarmLabel.font = .s1
        alarmLabel.textColor = .smeemBlack
        return alarmLabel
    }()
    
    private let alarmContainer: UIView = {
        let alarmContainer = UIView()
        alarmContainer.backgroundColor = .clear
        alarmContainer.layer.borderWidth = 1.5
        alarmContainer.layer.borderColor = UIColor.gray100.cgColor
        alarmContainer.makeRoundCorner(cornerRadius: 6)
        return alarmContainer
    }()
    
    private let alarmPushLabel: UILabel = {
        let pushLabel = UILabel()
        pushLabel.text = "트레이닝 푸시알림"
        pushLabel.font = .b4
        pushLabel.textColor = .smeemBlack
        return pushLabel
    }()
    
    private lazy var alarmPushToggleButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.btnToggleActive, for: .normal)
        button.addTarget(self, action: #selector(pushButtonDidTap(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var alarmCollectionView = AlarmCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setLayout()
        myPageInfoAPI()
    }
    
    // MARK: - @objc
    
    @objc func backButtonDidTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func moreButtonDidTap(_ sender: UIButton) {
        
    }
    
    @objc func editButtonDidTap(_ sender: UIButton) {
        let editVC = EditNicknameViewController()
        editVC.nickName = userInfo.username
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    @objc func pushButtonDidTap(_ sender: UIButton) {
        userInfo.hasPushAlarm.toggle() // 추후 서버 연결
        let image = userInfo.hasPushAlarm ? Constant.Image.btnToggleActive : Constant.Image.btnToggleInActive
        alarmPushToggleButton.setImage(image, for: .normal)
    }
    
    // MARK: - Custom Method
    
    private func setData() {
        nickNameLabel.text = userInfo.username
        //badgeImage.updateServerImage(userInfo.i
    }
    
    // MARK: - Layout
    
    private func setBackgroundColor() {
        view.backgroundColor = .white
    }
    
    private func setLayout() {
        setBackgroundColor()
        hiddenNavigationBar()
        
        view.addSubviews(headerContainerView, scrollView)
        headerContainerView.addSubviews(backButton, titleLabel, moreButton)
        scrollView.addSubview(contentView)
        contentView.addSubviews(nickNameLabel, editButton, howLearningView, badgeLabel, badgeContainer, languageLabel, languageContainer, alarmLabel, alarmContainer, alarmCollectionView)
        badgeContainer.addSubviews(badgeImage, badgeNameLabel, badgeSummaryLabel)
        languageContainer.addSubviews(languageLabelEnglish, languageCheckButton)
        alarmContainer.addSubviews(alarmPushLabel, alarmPushToggleButton)
    
        headerContainerView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(convertByHeightRatio(66))
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.width.height.equalTo(45)
        }
        
        titleLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-10)
            $0.width.height.equalTo(45)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(headerContainerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(convertByHeightRatio(30))
            $0.leading.equalToSuperview().offset(convertByWidthRatio(38))
        }
        
        editButton.snp.makeConstraints {
            $0.centerY.equalTo(nickNameLabel.snp.centerY)
            $0.leading.equalTo(nickNameLabel.snp.trailing)
            $0.width.height.equalTo(convertByWidthRatio(25))
        }
        
        howLearningView.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(convertByHeightRatio(16))
            $0.leading.equalToSuperview().inset(convertByWidthRatio(24))
            $0.centerX.equalToSuperview()
        }
        
        badgeLabel.snp.makeConstraints {
            $0.top.equalTo(howLearningView.snp.bottom).offset(convertByHeightRatio(52))
            $0.leading.equalToSuperview().inset(convertByWidthRatio(24))
        }
        
        badgeContainer.snp.makeConstraints {
            $0.top.equalTo(badgeLabel.snp.bottom).offset(convertByHeightRatio(14))
            $0.leading.trailing.equalTo(howLearningView)
            $0.height.equalTo(convertByHeightRatio(244))
        }
        
        badgeImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(convertByHeightRatio(40))
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(convertByWidthRatio(100))
        }
        
        badgeNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(convertByHeightRatio(162))
            $0.centerX.equalToSuperview()
        }
        
        badgeSummaryLabel.snp.makeConstraints {
            $0.top.equalTo(badgeNameLabel.snp.bottom).offset(convertByHeightRatio(8))
            $0.centerX.equalToSuperview()
        }
        
        languageLabel.snp.makeConstraints {
            $0.top.equalTo(badgeContainer.snp.bottom).offset(convertByHeightRatio(52))
            $0.leading.equalToSuperview().inset(convertByWidthRatio(24))
        }
        
        languageContainer.snp.makeConstraints {
            $0.top.equalTo(languageLabel.snp.bottom).offset(convertByHeightRatio(14))
            $0.leading.trailing.equalTo(howLearningView)
            $0.height.equalTo(convertByHeightRatio(54))
        }
        
        languageLabelEnglish.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(convertByWidthRatio(20))
        }
        
        languageCheckButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-convertByWidthRatio(13))
            $0.width.height.equalTo(convertByWidthRatio(40))
        }
        
        alarmLabel.snp.makeConstraints {
            $0.top.equalTo(languageContainer.snp.bottom).offset(convertByHeightRatio(52))
            $0.leading.equalToSuperview().inset(convertByWidthRatio(24))
        }
        
        alarmContainer.snp.makeConstraints {
            $0.top.equalTo(alarmLabel.snp.bottom).offset(convertByHeightRatio(14))
            $0.leading.trailing.equalTo(howLearningView)
            $0.height.equalTo(convertByHeightRatio(54))
        }
        
        alarmPushLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(convertByWidthRatio(20))
        }
        
        alarmPushToggleButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-convertByWidthRatio(13))
            $0.width.equalTo(convertByWidthRatio(36))
        }
        
        alarmCollectionView.snp.makeConstraints {
            $0.top.equalTo(alarmContainer.snp.bottom).offset(convertByHeightRatio(10))
            $0.leading.trailing.equalToSuperview().inset(23)
            $0.height.equalTo(convertByHeightRatio(133))
            $0.bottom.equalToSuperview().offset(-convertByHeightRatio(80))
        }
    }
}

// MARK: - Extension : Network

extension MyPageViewController {
    func myPageInfoAPI() {
        MyPageAPI.shared.myPageInfo() { response in
            guard let myPageInfo = response?.data else { return }
            self.userInfo = myPageInfo
            self.setData()
        }
    }
}
