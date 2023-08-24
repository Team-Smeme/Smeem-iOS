//
//  EditGoalViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/08/13.
//

import UIKit

final class EditGoalViewController: UIViewController {
    
    var tempTarget = String()
    var planName = String()
    var planWay = String()
    var planDetailWay = "" {
        didSet {
            configurePlanData()
        }
    }
    
    private let navigationBarView = UIView()
    private let loadingView = LoadingView()
    
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
    
    private let howLearningView: HowLearningView = {
        let view = HowLearningView()
        view.buttontype = .logo
        return view
    }()
    
    private lazy var nextButton: SmeemButton = {
        let button = SmeemButton()
        button.smeemButtonType = .enabled
        button.setTitle("완료", for: .normal)
        button.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setBackgroundColor()
        print("dfkajfhdksafjasdf", tempTarget)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        detailPlanListGetAPI(tempTarget: tempTarget)
    }
    
    private func setBackgroundColor() {
        view.backgroundColor = .white
    }
    
    private func configurePlanData() {
        let planNameList = planWay.components(separatedBy: " 이상 ")
        let planWayOne = planNameList[0] + " 이상"
        let planWayTwo = planNameList[1]
        let detailPlan = planDetailWay.split(separator: "\n").map{String($0)}
        
        howLearningView.setData(planName: planName, planWayOne: planWayOne, planWayTwo: planWayTwo, detailPlanOne: detailPlan[0], detailPlanTwo: detailPlan[1])
    }

}

extension EditGoalViewController {

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

extension EditGoalViewController {
    func patchGoalAPI(target: String) {
        MyPageAPI.shared.changeGoal(param: EditGoalRequest(target: target)) { response in
            
            guard let _ = response.data else { return }
            
            NotificationCenter.default.post(name: NSNotification.Name("goalData"), object: true)
            
            if let navigationController = self.navigationController {
                let viewControllers = navigationController.viewControllers
                if viewControllers.count >= 2 {
                    let viewControllerToPopTo = viewControllers[viewControllers.count - 3] // 해당 인덱스에 있는 뷰 컨트롤러로 돌아가려면 -3로 설정합니다.
                    navigationController.popToViewController(viewControllerToPopTo, animated: true)
                }
            }
        }
    }
    
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
