//
//  GoalOnboardingViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/14.
//

import UIKit

final class GoalOnboardingViewController: UIViewController {
    
    // MARK: - Property
    
    var goalLabelList = [Plan]() {
        didSet {
            learningListCollectionView.reloadData()
        }
    }
    var selectedGoalLabel = String()
    
    var targetClosure: ((String) -> Void)?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        setLayout()
        setDelgate()
        setCellReigster()
        hiddenNavigationBar()
        planListGetAPI()
        
        print(UserDefaults.standard.string(forKey: "accessToken"))
        print(UserDefaultsManager.accessToken)
        print("⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️")
        print(NetworkConstant.hasAccessTokenHeader)
    }
    
    // MARK: - @objc
    
    @objc func nextButtonDidTap() {
        let howOnboardingVC = HowOnboardingViewController()
        howOnboardingVC.tempTarget = selectedGoalLabel
        self.navigationController?.pushViewController(howOnboardingVC, animated: true)
    }
    
    // MARK: - Custom Method
    
    private func setDelgate() {
        learningListCollectionView.delegate = self
        learningListCollectionView.dataSource = self
    }
    
    private func setCellReigster() {
        learningListCollectionView.register(GoalCollectionViewCell.self, forCellWithReuseIdentifier: GoalCollectionViewCell.identifier)
    }
    
    private func setBackgroundColor() {
        view.backgroundColor = .white
    }
    
    // MARK: - Layout
    
    private func setLayout() {
        view.addSubviews(nowStepOneLabel, divisionLabel, totalStepLabel,
                         learningLabelStackView, learningListCollectionView,
                         nextButton)
        learningLabelStackView.addArrangedSubviews(titleLearningLabel, detailLearningLabel)
        
        nowStepOneLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(26)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(36)
        }
        
        divisionLabel.snp.makeConstraints {
            $0.leading.equalTo(nowStepOneLabel.snp.trailing).offset(2)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(40)
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
}

extension GoalOnboardingViewController {
    func planListGetAPI() {
        OnboardingAPI.shared.planList() { response in
            guard let data = response.data?.goals else { return }
            self.goalLabelList = data
        }
    }
}

// MARK: - UICollectionViewDelegate

extension GoalOnboardingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedGoalLabel = goalLabelList[indexPath.item].goalType
        nextButton.smeemButtonType = .enabled
    }
}

// MARK: - UICollectionViewDataSource

extension GoalOnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goalLabelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalCollectionViewCell.identifier, for: indexPath) as? GoalCollectionViewCell else { return UICollectionViewCell() }
        cell.setData(goalLabelList[indexPath.item].name)
        return cell
    }
}

extension GoalOnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = convertByHeightRatio(60)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let cellLineSpacing: CGFloat = 12
        return cellLineSpacing
    }
}
