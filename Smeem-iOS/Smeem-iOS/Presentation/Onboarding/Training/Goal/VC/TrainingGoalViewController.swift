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

final class TrainingGoalViewController: BaseViewController {
    
    private let viewModel = TrainingGoalViewModel()
    
    // MARK: - Subject
    
    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    private let amplitudeSubject = PassthroughSubject<Void, Never>()
    private let cellTapped = PassthroughSubject<(String, SmeemButtonType), Never>()
    private let nextButtonTapped = PassthroughSubject<Void, Never>()
    private var cancelbag = Set<AnyCancellable>()
    
    // MARK: - UI Components
    
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
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
        setDelegate()
        bind()
        sendInput()
    }
    
    // MARK: Methods
    
    private func bind() {
        nextButton.tapPublisher
            .sink { [weak self] _ in
                self?.nextButtonTapped.send(())
            }
            .store(in: &cancelbag)
        
        let input = TrainingGoalViewModel.Input(viewDidLoadSubject: viewDidLoadSubject,
                                                cellTapped: cellTapped,
                                                nextButtonTapped: nextButtonTapped,
                                                amplitudeSubject: amplitudeSubject)
        let output = viewModel.transform(input: input)
        
        output.viewDidLoadResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                self?.trainingGoalCollectionView.planGoalArray = response
                self?.trainingGoalCollectionView.reloadData()
            }
            .store(in: &cancelbag)
        
        output.cellResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] type in
                self?.nextButton.changeButtonType(buttonType: type)
            }
            .store(in: &cancelbag)
        
        output.nextButtonResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] target in
                let trainingPlanVC = TrainingPlanViewController(target: target)
                self?.navigationController?.pushViewController(trainingPlanVC, animated: true)
            }
            .store(in: &cancelbag)
        
        output.errorResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showToast(toastType: .smeemErrorToast(message: error))
            }
            .store(in: &cancelbag)
        
        output.loadingViewResult
            .receive(on: DispatchQueue.main)
            .sink { isShown in
                isShown ? SmeemLoadingView.showLoading() : SmeemLoadingView.hideLoading()
            }
            .store(in: &cancelbag)
    }
    
    private func setDelegate() {
        trainingGoalCollectionView.trainingDelegate = self
    }
    
    private func sendInput() {
        viewDidLoadSubject.send(())
        amplitudeSubject.send(())
    }
}

// MARK: - Delegate

extension TrainingGoalViewController: TrainingDataSendDelegate {
    func sendTargetData(targetString: String, buttonType: SmeemButtonType) {
        self.cellTapped.send((targetString, buttonType))
    }
}

// MARK: - Layout

extension TrainingGoalViewController {
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
