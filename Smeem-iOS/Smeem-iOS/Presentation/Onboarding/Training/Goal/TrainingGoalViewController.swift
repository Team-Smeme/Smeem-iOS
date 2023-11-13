//
//  PlanGoalViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/10/08.
//

import UIKit

final class TrainingGoalViewController: BaseViewController {
    
    // MARK: Properties
    
    private var targetString = ""
    private var goalsArray: [TrainingGoals] = []
    
    // MARK: Network Manager
    
    private let trainingManager: TrainingManager
    
    // MARK: UI Properties
    
    private lazy var trainingStepView = TrainingStepView(type: .goal)
    private lazy var planGoalCollectionView = TrainingGoalsCollectionView(planGoalType: .onboarding)
    private lazy var nextButton = SmeemButton(buttonType: .notEnabled, text: "다음")
    
    // MARK: Life Cycle
    
    init(trainingManager: TrainingManager) {
        self.trainingManager = trainingManager
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        trainingGoalsGetAPI()
        setTrainingDelegate()
    }
    
    // MARK: Button Action
    
    override func setButtonAction() {
        nextButton.addAction {
            let trainingWayVC = TrainingWayViewController(trainingManager: TrainingManager(trainingService: TrainingService(requestable: APIServie())))
            trainingWayVC.targetString = self.targetString
            self.navigationController?.pushViewController(trainingWayVC, animated: true)
        }
    }
}

// MARK: - Network

extension TrainingGoalViewController: ViewControllerServiceable {
    private func trainingGoalsGetAPI() {
        Task {
            do {
                showLoadingView()
                goalsArray = try await trainingManager.getTrainingGoal()
                planGoalCollectionView.planGoalArray = goalsArray
            } catch {
                guard let error = error as? NetworkError else { return }
                handlerError(error)
            }
            hideLoadingView()
        }
    }
}

// MARK: - TrainingDelegate

extension TrainingGoalViewController: TrainingDataSendDelegate {
    func setTrainingDelegate() {
        planGoalCollectionView.trainingDelegate = self
    }
    
    func sendButtonState() {
        self.nextButton.changeButtonType(buttonType: .enabled)
    }
    
    func sendTargetString(targetString: String) {
        self.targetString = targetString
    }
}

// MARK: - Layout

extension TrainingGoalViewController {
    private func setLayout() {
        view.addSubviews(trainingStepView, planGoalCollectionView, nextButton)
        
        trainingStepView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(36)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(view.frame.width)
            $0.height.equalTo(convertByHeightRatio(94))
        }
        
        planGoalCollectionView.snp.makeConstraints {
            $0.top.equalTo(trainingStepView.snp.bottom).offset(28)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(planGoalCollectionView.snp.bottom).offset(70)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(18)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(convertByHeightRatio(60))
        }
    }
}
