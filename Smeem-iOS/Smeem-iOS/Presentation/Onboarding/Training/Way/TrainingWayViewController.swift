//
//  TrainingHowViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/10/10.
//

import UIKit

final class TrainingWayViewController: BaseViewController {
    
    // MARK: Properties
    
    var targetString = ""
    
    // MARK: Network Manager
    
    private let trainingManager: TrainingManager
    
    // MARK: UI Properties
    
    private let trainingWayStepView = TrainingStepView(configuration: TrainingStepFactory().createTrainingWayStepView())
    private let trainingWayView = TrainingWayView()
    private lazy var nextButton = SmeemButton(buttonType: .enabled, text: "다음")
    
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
        trainingHowGetAPI(query: targetString)
    }
    
    // MARK: Custom Method
    
    override func setButtonAction() {
        nextButton.addAction {
            let trainingAlarmVC = TrainingAlarmViewController(trainingManager: TrainingManager(trainingService: TrainingService(requestable: RequestImpl())))
            trainingAlarmVC.targetString = self.targetString
            self.navigationController?.pushViewController(trainingAlarmVC, animated: true)
        }
    }
}

// MARK: Extension - Network

extension TrainingWayViewController: ViewControllerServiceable {
    private func trainingHowGetAPI(query: String) {
        Task {
            showLoadingView()
            do {
                let clientModel = try await trainingManager.getTrainingHow(query: query)
                self.trainingWayView.setRefactorData(model: clientModel)
                hideLoadingView()
            } catch {
                guard let error = error as? NetworkError else { return }
                handlerError(error)
            }
        }
    }
}

// MARK: Extension - Layout

extension TrainingWayViewController {
    private func setLayout() {
        view.addSubviews(trainingWayStepView, trainingWayView, nextButton)
        
        trainingWayStepView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(36)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(view.frame.width)
            $0.height.equalTo(convertByHeightRatio(94))
        }
        
        trainingWayView.snp.makeConstraints {
            $0.top.equalTo(trainingWayStepView.snp.bottom).offset(28)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(trainingWayView.snp.bottom).offset(30).priority(.low)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(18)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(convertByHeightRatio(60))
        }
    }
}
