//
//  GoalOnboardingViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/14.
//

import UIKit
import Combine

enum TrainingGoalType {
    case onboarding
    case myPage
}

final class TrainingGoalViewController: BaseViewController, UICollectionViewDelegate {
    
    // MARK: - Property
    
    private var tempTarget = ""
    
    private let viewDidLoadSubject = PassthroughSubject<Void, Error>()
    private let cellTapped = PassthroughSubject<(String, SmeemButtonType), Error>()
    private let nextButtonTapped = PassthroughSubject<String, Error>()
    
//    private let viewModel: TrainingGoalViewModel
    
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
        label.text = "트레이닝 목표 설정"
        label.font = .h2
        label.textColor = .black
        return label
    }()
    
    private let detailLearningLabel: UILabel = {
        let label = UILabel()
        label.text = "마이페이지에서 언제든지 수정할 수 있어요!"
        label.font = .b4
        label.textColor = .black
        return label
    }()
    
    private let trainingLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 6
        return stackView
    }()
    
    private let trainingGoalCollectionView = TrainingGoalsCollectionView(planGoalType: .onboarding)
    
    private lazy var nextButton: SmeemButton = {
        let button = SmeemButton(buttonType: .notEnabled, text: "다음")
        button.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    
//    init(viewModel: TrainingGoalViewModel) {
//        self.viewModel = viewModel
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
        viewDidLoadSubject.send(())
        planListGetAPI()
        setDelegate()
        AmplitudeManager.shared.track(event: AmplitudeConstant.Onboarding.onboarding_goal_view.event)
    }
    
//    private func bind() {
//        let output = viewModel.transform(input: TrainingGoalViewModel.Input(viewDidLoadSubject: viewDidLoadSubject,
//                                                                           cellTapped: cellTapped,
//                                                                           nextButtonTapped: nextButtonTapped))
//
//
//    };
    
    @objc func nextButtonDidTap() {
        let howOnboardingVC = HowOnboardingViewController()
        howOnboardingVC.tempTarget = tempTarget
        self.navigationController?.pushViewController(howOnboardingVC, animated: true)
    }
    
    private func setDelegate() {
        trainingGoalCollectionView.trainingDelegate = self
    }
    
    private func setLayout() {
        view.addSubviews(nowStepOneLabel, divisionLabel, totalStepLabel, trainingLabelStackView, trainingGoalCollectionView, nextButton)
        trainingLabelStackView.addArrangedSubviews(titleLearningLabel, detailLearningLabel)
        
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
        
        trainingLabelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(26)
            $0.top.equalTo(totalStepLabel.snp.bottom).offset(19)
        }
        
        trainingGoalCollectionView.snp.makeConstraints {
            $0.top.equalTo(trainingLabelStackView.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.bottom).offset(80)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(50)
            $0.height.equalTo(convertByHeightRatio(60))
        }
    }
}

extension TrainingGoalViewController: TrainingDataSendDelegate {
    func sendTargetData(targetString: String, buttonType: SmeemButtonType) {
        self.nextButton.changeButtonType(buttonType: buttonType)
        self.tempTarget = targetString
    }
}

// MARK: - Network

extension TrainingGoalViewController {
    func planListGetAPI() {
        SmeemLoadingView.showLoading()
        OnboardingAPI.shared.planList() { response in
            
            switch response {
            case .success(let response):
                self.trainingGoalCollectionView.planGoalArray = response
                self.trainingGoalCollectionView.reloadData()
            case .failure(let error):
                self.showToast(toastType: .smeemErrorToast(message: error))
            }
            
            SmeemLoadingView.hideLoading()
        }
    }
}

