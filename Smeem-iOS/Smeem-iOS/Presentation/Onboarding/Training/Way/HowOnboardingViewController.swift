//
//  HowOnboardingViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/16.
//

import UIKit

final class HowOnboardingViewController: BaseViewController {
    
    // MARK: - Property
    
    var tempTarget = String()
    var planName = String()
    var planWay = String()
    var planDetailWay = "" {
        didSet {
            configurePlanData()
        }
    }
    
    // MARK: - UI Property
    
    private let loadingView = LoadingView()
    
    private let nowStepOneLabel: UILabel = {
        let label = UILabel()
        label.text = "2"
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
        label.text = "추천 트레이닝 방법"
        label.font = .h2
        label.textColor = .black
        return label
    }()
    
    private let detailLearningLabel: UILabel = {
        let label = UILabel()
        label.text = "스밈과 함께한다면 분명 목표를 이룰 거예요!"
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
    
    private let howLearningView: TrainingWayView = {
        let view = TrainingWayView(type: .none)
        return view
    }()
    
    private lazy var nextButton: SmeemButton = {
        let button = SmeemButton(buttonType: .enabled, text: "다음")
        button.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        detailPlanListGetAPI(tempTarget: tempTarget)
    }
    
    // MARK: - @objc
    
    @objc func nextButtonDidTap() {
        let alarmVC = AlarmSettingViewController()
        alarmVC.targetData = tempTarget
        self.navigationController?.pushViewController(alarmVC, animated: true)
    }
    
    // MARK: - Custom Method
    
    private func configurePlanData() {
        let planNameList = planWay.components(separatedBy: " 이상 ")
        let planWayOne = planNameList[0] + " 이상"
        let planWayTwo = planNameList[1]
        let detailPlan = planDetailWay.split(separator: "\n").map{String($0)}
        
        howLearningView.setData(planName: planName, planWayOne: planWayOne, planWayTwo: planWayTwo, detailPlanOne: detailPlan[0], detailPlanTwo: detailPlan[1])
    }
    
    // MARK: - Layout
    
    private func setLayout() {
        view.addSubviews(nowStepOneLabel, divisionLabel, totalStepLabel, learningLabelStackView, howLearningView, nextButton)
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
        
        howLearningView.snp.makeConstraints {
            $0.top.equalTo(learningLabelStackView.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(50)
            $0.height.equalTo(convertByHeightRatio(60))
        }
    }
}

// MARK: - Network

extension HowOnboardingViewController {
    func detailPlanListGetAPI(tempTarget: String) {
        self.showLodingView(loadingView: loadingView)
        OnboardingAPI.shared.detailPlanList(param: tempTarget) { response in
            guard let data = response.data else { return }

            self.hideLodingView(loadingView: self.loadingView)

            self.planName = data.name
            self.planWay = data.way
            self.planDetailWay = data.detail

            self.configurePlanData()
        }
    }
}
