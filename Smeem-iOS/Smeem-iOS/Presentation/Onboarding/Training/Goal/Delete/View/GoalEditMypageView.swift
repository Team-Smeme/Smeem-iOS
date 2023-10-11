//
//  GoalEditMypageView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/08/12.
//

import UIKit

import SnapKit

final class GoalEditMypageView: UIView {
    
    // MARK: - Property
    
    weak var nextButtonDelegate: NextButtonDelegate?
    
    var onDataSourceUpdated: (() -> Void)?
    
    var initialIndexPath: IndexPath?
    
    // MARK: - UI Property
    
    private let navigationBarView = UIView()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnBack, for: .normal)
        button.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "트레이닝 목표 변경"
        label.font = .s2
        label.textColor = .smeemBlack
        return label
    }()
    
    private lazy var learningListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var nextButton: SmeemButton = {
        let button = SmeemButton(buttonType: .notEnabled, text: "다음")
        button.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
        setBackgroundColor()
        setCellReigster()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Extensions

extension GoalEditMypageView {
    
    // MARK: - Layout
    
    private func setLayout() {
        addSubviews(navigationBarView, learningListCollectionView,
                    nextButton)
        navigationBarView.addSubviews(backButton, titleLabel)
        
        navigationBarView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeAreaLayoutGuide)
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
        
        learningListCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.top.equalTo(navigationBarView.snp.bottom).offset(28)
            $0.bottom.equalToSuperview().inset(178)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(50)
            $0.height.equalTo(convertByHeightRatio(60))
        }
    }
    
    // MARK: - @objc
    
    @objc func nextButtonDidTap() {
        nextButtonDelegate?.nextButtonDidTap()
    }
    
    @objc func backButtonDidTap() {
        nextButtonDelegate?.backButtonDidTap()
    }
    
    // MARK: - Custom Method
    
    func enableNextButton() {
        nextButton.changeButtonType(buttonType: .enabled)
//        nextButton.smeemButtonType = .enabled
    }
    
    func disableNextButton() {
        // TODO: 이거 disabled로 고치는건 어떨까요?!?
        nextButton.changeButtonType(buttonType: .notEnabled)
//        nextButton.smeemButtonType = .notEnabled
    }
    
    func setCollectionViewDataSource(dataSource: UICollectionViewDataSource) {
        learningListCollectionView.dataSource = dataSource
        learningListCollectionView.reloadData()
    }
    
    func setCollectionViewDelgate(delegate: UICollectionViewDelegate & UICollectionViewDelegateFlowLayout) {
        learningListCollectionView.delegate = delegate
    }
    
    private func setCellReigster() {
        learningListCollectionView.register(TrainingGoalCollectionViewCell.self, forCellWithReuseIdentifier: TrainingGoalCollectionViewCell.description())
    }
    
    func setData(selectedGoalIndex: Int) {
        if let dataSource = learningListCollectionView.dataSource as? GoalCollectionViewDataSource {
            // 데이터 소스의 selectedIndex 값을 업데이트
            dataSource.setSelectedIndex(selectedGoalIndex)
            // collectionView reloadData 호출
            learningListCollectionView.reloadData()
        }
    }
    
    private func setBackgroundColor() {
        backgroundColor = .white
    }
}
