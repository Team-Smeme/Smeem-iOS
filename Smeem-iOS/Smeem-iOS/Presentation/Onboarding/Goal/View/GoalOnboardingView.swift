//
//  GoalOnboardingView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/08/12.
//

import UIKit

import SnapKit

final class GoalOnboardingView: UIView {
    
    // MARK: - Property
    
    weak var delegate: NextButtonDelegate?
    
    var onDataSourceUpdated: (() -> Void)?
    
    // MARK: - UI Property
    
    private let nowStepOneLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = .s1
        label.setTextWithLineHeight(lineHeight: 21)
        label.textColor = .point
        return label
    }()
    
    private let divisionLabel: UILabel = {
        let label = UILabel()
        label.text = "/"
        label.font = .c3
        label.textColor = .black
        return label
    }()
    
    private let totalStepLabel: UILabel = {
        let label = UILabel()
        label.text = "3"
        label.font = .c3
        label.textColor = .black
        return label
    }()
    
    private let titleLearningLabel: UILabel = {
        let label = UILabel()
        label.text = "학습 목표 설정"
        label.font = .h2
        label.textColor = .black
        return label
    }()
    
    private let detailLearningLabel: UILabel = {
        let label = UILabel()
        label.text = "학습 목표는 마이페이지에서 수정할 수 있어요"
        label.font = .b4
        label.textColor = .black
        return label
    }()
    
    private let learningLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 6
        return stackView
    }()
    
    private lazy var learningListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var nextButton: SmeemButton = {
        let button = SmeemButton()
        button.smeemButtonType = .notEnabled
        button.setTitle("다음", for: .normal)
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

extension GoalOnboardingView {
    
    // MARK: - Layout
    
    private func setLayout() {
        addSubviews(nowStepOneLabel, divisionLabel, totalStepLabel,
                    learningLabelStackView, learningListCollectionView,
                    nextButton)
        learningLabelStackView.addArrangedSubviews(titleLearningLabel, detailLearningLabel)
        
        nowStepOneLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(26)
            $0.top.equalTo(safeAreaLayoutGuide).inset(36)
        }
        
        divisionLabel.snp.makeConstraints {
            $0.leading.equalTo(nowStepOneLabel.snp.trailing).offset(2)
            $0.top.equalTo(safeAreaLayoutGuide).inset(40)
        }
        
        totalStepLabel.snp.makeConstraints {
            $0.leading.equalTo(divisionLabel.snp.trailing).offset(1)
            $0.top.equalTo(divisionLabel.snp.top)
        }
        
        learningLabelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(26)
            $0.top.equalTo(totalStepLabel.snp.bottom).offset(19)
        }
        
        learningListCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.top.equalTo(learningLabelStackView.snp.bottom).offset(28)
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
        delegate?.nextButtonDidTap()
    }
    
    // MARK: - Custom Method
    
    func enableNextButton() {
        nextButton.smeemButtonType = .enabled
    }
    
    func disableNextButton() {
        // TODO: 이거 disabled로 고치는건 어떨까요?!?
        
        nextButton.smeemButtonType = .notEnabled
    }
    
    func setCollectionViewDataSource(dataSource: UICollectionViewDataSource) {
        learningListCollectionView.dataSource = dataSource
        learningListCollectionView.reloadData()
    }
    
    func setCollectionViewDelgate(delegate: UICollectionViewDelegate & UICollectionViewDelegateFlowLayout) {
        learningListCollectionView.delegate = delegate
    }
    
    private func setCellReigster() {
        learningListCollectionView.register(GoalCollectionViewCell.self, forCellWithReuseIdentifier: GoalCollectionViewCell.identifier)
    }
    
    private func setBackgroundColor() {
        backgroundColor = .white
    }
}
