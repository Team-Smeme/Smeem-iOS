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
    
    private var nickName: String = "주멩이"
    
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
        nickNameLabel.text = nickName
        nickNameLabel.font = .h3
        nickNameLabel.textColor = .smeemBlack
        return nickNameLabel
    }()
    
    private let editButton: UIButton = {
        let editButton = UIButton()
        editButton.setImage(Constant.Image.icnPencil, for: .normal)
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
    
    private lazy var alarmCollectionView = AlarmCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setLayout()
    }
    
    // MARK: - @objc
    
    @objc func backButtonDidTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func moreButtonDidTap(_ sender: UIButton) {

    }
    
    // MARK: - Custom Method
    
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
        //badgeContainer.addSubviews(<#T##UIView...#>)
        languageContainer.addSubviews(languageLabelEnglish, languageCheckButton)
        //alarmContainer.addSubviews(<#T##UIView...#>)
        
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
        
        alarmCollectionView.snp.makeConstraints {
            $0.top.equalTo(alarmContainer.snp.bottom).offset(convertByHeightRatio(10))
            $0.leading.trailing.equalToSuperview().inset(23)
            $0.height.equalTo(convertByHeightRatio(133))
            $0.bottom.equalToSuperview().offset(-convertByHeightRatio(80))
        }
    }
}
