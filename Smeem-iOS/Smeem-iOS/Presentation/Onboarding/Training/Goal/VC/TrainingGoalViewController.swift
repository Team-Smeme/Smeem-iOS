//
//  GoalOnboardingViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/14.
//

import UIKit

enum TrainingGoalType {
    case onboarding
    case myPage
}

final class TrainingGoalViewController: BaseViewController {
    
    // MARK: - Property
    
    private var viewtype: TrainingGoalType
    
    private let goalOnboardingView = GoalEditMypageView()
    private let goalEditMypageView = GoalEditMypageView()
    
    private let datasource = GoalCollectionViewDataSource()
    
    var targetClosure: ((String) -> Void)?
    
    var selectedGoalIndex: Int?
    var selectedGoalLabel = "" {
        didSet {
            setButtonType()
        }
    }
    
    // MARK: - Life Cycle
    
    init(viewtype: TrainingGoalType, targetClosure: ( (String) -> Void)? = nil, selectedGoalLabel: String = String()) {
        self.viewtype = viewtype
        self.targetClosure = targetClosure
        self.selectedGoalLabel = selectedGoalLabel
        
        if self.viewtype == .onboarding {
            AmplitudeManager.shared.track(event: AmplitudeConstant.Onboarding.onboarding_goal_view.event)
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        configureViewType()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        planListGetAPI()
        setCollectionViewOnDataSourceUpdate()
        
        if let selectedGoalIndex = selectedGoalIndex {
            datasource.setSelectedIndex(selectedGoalIndex)
        }
    }
    
    private func setButtonType() {
        if selectedGoalLabel != "" {
            goalOnboardingView.enableNextButton()
            goalEditMypageView.enableNextButton()
        } else {
            goalOnboardingView.disableNextButton()
            goalEditMypageView.disableNextButton()
        }
    }
}

// MARK: - NextButtonDelegate

extension TrainingGoalViewController: NextButtonDelegate {
    func nextButtonDidTap() {
        switch viewtype {
        case .onboarding:
            print("임시 코드")
            let howOnboardingVC = HowOnboardingViewController()
            howOnboardingVC.tempTarget = selectedGoalLabel
            self.navigationController?.pushViewController(howOnboardingVC, animated: true)
        case .myPage:
            let howOnboardingVC = EditGoalViewController()
            howOnboardingVC.tempTarget = selectedGoalLabel
            self.navigationController?.pushViewController(howOnboardingVC, animated: true)
        }
    }
    
    func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Extensions

extension TrainingGoalViewController {
    
    private func configureViewType() {
        switch viewtype {
        case .onboarding:
            view = goalOnboardingView
            goalOnboardingView.nextButtonDelegate = self
            goalOnboardingView.setCollectionViewDataSource(dataSource: datasource)
            goalOnboardingView.setCollectionViewDelgate(delegate: self)
        case .myPage:
            view = goalEditMypageView
            goalEditMypageView.nextButtonDelegate = self
            goalEditMypageView.setCollectionViewDataSource(dataSource: datasource)
            goalEditMypageView.setCollectionViewDelgate(delegate: self)
        }
    }
    
    func setCollectionViewOnDataSourceUpdate() {
        goalOnboardingView.onDataSourceUpdated = { [weak self] in
            self?.refreshCollectionViewDataSource()
        }
    }
    
    func refreshCollectionViewDataSource() {
        goalOnboardingView.setCollectionViewDataSource(dataSource: datasource)
        goalEditMypageView.setCollectionViewDataSource(dataSource: datasource)
    }
}

// MARK: - UICollectionViewDelegate

extension TrainingGoalViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrainingGoalCollectionViewCell else { return }
        cell.selctedCell()
        
        selectedGoalLabel = datasource.goalLabelList[indexPath.item].goalType
        
        switch viewtype {
        case .onboarding:
            goalOnboardingView.enableNextButton()
        case .myPage:
            goalEditMypageView.enableNextButton()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrainingGoalCollectionViewCell else { return }
        cell.desecltedCell()
    }
}

extension TrainingGoalViewController: UICollectionViewDelegateFlowLayout {
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

// MARK: - Network

extension TrainingGoalViewController {
    func planListGetAPI() {
        SmeemLoadingView.showLoading()
        OnboardingAPI.shared.planList() { response in
            
            switch response {
            case .success(let response):
                self.datasource.goalLabelList = response.goals
                self.goalOnboardingView.onDataSourceUpdated?()
            case .failure(let error):
                self.showToast(toastType: .smeemErrorToast(message: error))
            }
            
            SmeemLoadingView.hideLoading()
        }
    }
}
