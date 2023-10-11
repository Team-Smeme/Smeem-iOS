//
//  GoalOnboardingViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/14.
//

import UIKit

enum GoalViewType {
    case onboarding
    case myPage
}

final class GoalViewController: UIViewController {
    
    // MARK: - Property
    
    private var viewtype: GoalViewType
    
    private let goalOnboardingView = GoalOnboardingView()
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
    
    init(viewtype: GoalViewType, targetClosure: ( (String) -> Void)? = nil, selectedGoalLabel: String = String()) {
        self.viewtype = viewtype
        self.targetClosure = targetClosure
        self.selectedGoalLabel = selectedGoalLabel
        
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
        
        hiddenNavigationBar()
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

extension GoalViewController: NextButtonDelegate {
    func nextButtonDidTap() {
        switch viewtype {
        case .onboarding:
            print("임시 코드")
//            let howOnboardingVC = HowOnboardingViewController()
//            howOnboardingVC.tempTarget = selectedGoalLabel
//            self.navigationController?.pushViewController(howOnboardingVC, animated: true)
        case .myPage:
            let howOnboardingVC = EditGoalViewController(editGoalManager: MyPageEditManager(myPageEditService: MyPageEditService(requestable: RequestImpl())))
            howOnboardingVC.tempTarget = selectedGoalLabel
            self.navigationController?.pushViewController(howOnboardingVC, animated: true)
        }
    }
    
    func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Extensions

extension GoalViewController {
    
    private func configureViewType() {
        switch viewtype {
        case .onboarding:
            view = goalOnboardingView
            goalOnboardingView.delegate = self
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

extension GoalViewController: UICollectionViewDelegate {
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

extension GoalViewController: UICollectionViewDelegateFlowLayout {
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

extension GoalViewController {
    func planListGetAPI() {
        OnboardingAPI.shared.planList() { response in
            guard let data = response.data?.goals else { return }
            self.datasource.goalLabelList = data
            
            DispatchQueue.main.async {
                self.goalOnboardingView.onDataSourceUpdated?()
            }
        }
    }
}

