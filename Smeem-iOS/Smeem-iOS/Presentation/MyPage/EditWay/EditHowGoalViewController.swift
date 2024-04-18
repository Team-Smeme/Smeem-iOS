//
//  EditGoalViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/08/13.
//

import UIKit

final class EditHowGoalViewController: BaseViewController {
    
    private let provider = OnboardingService()

    var tempTarget = String()
    var planName = String()
    var planWay = String()
    var planDetailWay = "" {
        didSet {
            configurePlanData()
        }
    }
    
    weak var delegate: EditMypageDelegate?
    
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
    
    private let howLearningView: TrainingWayView = {
        let view = TrainingWayView(type: .none)
        return view
    }()
    
    private lazy var nextButton: SmeemButton = {
        let button = SmeemButton(buttonType: .enabled, text: "완료")
        button.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        detailPlanListGetAPI(tempTarget: tempTarget)
    }
    
    private func configurePlanData() {
        let planNameList = planWay.components(separatedBy: " 이상 ")
        let planWayOne = planNameList[0] + " 이상"
        let planWayTwo = planNameList[1]
        let detailPlan = planDetailWay.split(separator: "\n").map{String($0)}
        
        howLearningView.setData(planName: planName, planWayOne: planWayOne, planWayTwo: planWayTwo, detailPlanOne: detailPlan[0], detailPlanTwo: detailPlan[1])
    }

}

extension EditHowGoalViewController {

    // MARK: - @objc
    
    @objc func backButtonDidTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func nextButtonDidTap() {
        patchGoalAPI(target: tempTarget)
    }
    
    // MARK: - Layout
    
    private func setLayout() {
        view.addSubviews(navigationBarView, howLearningView, nextButton)
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
        
        howLearningView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(50)
            $0.height.equalTo(convertByHeightRatio(60))
        }
    }
}

extension EditHowGoalViewController {
    func patchGoalAPI(target: String) {
        SmeemLoadingView.showLoading()
        
        MyPageAPI.shared.changeGoal(param: EditGoalRequest(target: target)) { result in
            
            switch result {
            case .success(_):
                NotificationCenter.default.post(name: NSNotification.Name("goalData"), object: true)
                
                if let navigationController = self.navigationController {
                    let viewControllers = navigationController.viewControllers
                    if viewControllers.count >= 2 {
                        let viewControllerToPopTo = viewControllers[viewControllers.count - 3] // 해당 인덱스에 있는 뷰 컨트롤러로 돌아가려면 -3로 설정합니다.
                        navigationController.popToViewController(viewControllerToPopTo, animated: true)
                    }
                }
            case .failure(let error):
                self.showToast(toastType: .smeemErrorToast(message: error))
            }
            
            SmeemLoadingView.hideLoading()
        }
    }
    
    func detailPlanListGetAPI(tempTarget: String) {
        SmeemLoadingView.showLoading()
        
        self.provider.trainingWayGetAPI(param: tempTarget) { result in
            switch result {
            case .success(let response):
                self.planName = response.title
                self.planWay = response.way
                self.planDetailWay = response.detail
                self.configurePlanData()
                
            case .failure(let error):
                self.showToast(toastType: .smeemErrorToast(message: error))
            }
            
            SmeemLoadingView.hideLoading()
        }
    }
}
