//
//  EditGoalViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2024/01/30.
//

import UIKit

final class EditGoalViewController: BaseViewController {
    
    private var targetIndex = -1
    private var tempTarget = ""
    
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
    
    private lazy var trainingGoalCollectionView = TrainingGoalsCollectionView(planGoalType: .myPage(targetIndex: targetIndex))
    
    private lazy var nextButton: SmeemButton = {
        let button = SmeemButton(buttonType: .enabled, text: "다음")
        button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return button
    }()
    
    init(targetIndex: Int, tempTarget: String) {
        super.init(nibName: nil, bundle: nil)
        self.targetIndex = targetIndex
        self.tempTarget = tempTarget
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        planListGetAPI()
        setDelegate()
    }
    
    private func setDelegate() {
        trainingGoalCollectionView.trainingDelegate = self
    }
    
    @objc func nextButtonTapped() {
        let editHowGoalVC = EditHowGoalViewController()
        editHowGoalVC.tempTarget = tempTarget
        self.navigationController?.pushViewController(editHowGoalVC, animated: true)
    }
    
    @objc func backButtonDidTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setLayout() {
        view.addSubviews(navigationBarView, trainingGoalCollectionView, nextButton)
        navigationBarView.addSubviews(backButton, titleLabel)
        
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(convertByHeightRatio(66))
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(55)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        trainingGoalCollectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom).offset(17)
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

extension EditGoalViewController: TrainingDataSendDelegate {
    func sendTargetData(targetString: String, buttonType: SmeemButtonType) {
        self.nextButton.changeButtonType(buttonType: buttonType)
        self.tempTarget = targetString
    }
}

// MARK: - Network

extension EditGoalViewController {
    func planListGetAPI() {
        SmeemLoadingView.showLoading()
        OnboardingService.shared.trainingGoalGetAPI() { response in
            
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
