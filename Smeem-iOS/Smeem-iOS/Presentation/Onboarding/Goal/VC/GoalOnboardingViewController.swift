//
//  GoalOnboardingViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/14.
//

import UIKit

final class GoalOnboardingViewController: UIViewController {
    
    // MARK: - Property
    
    private let goalOnboardingView = GoalOnboardingView()
    private let datasource = GoalOnboardingDataSource()
    
    var targetClosure: ((String) -> Void)?
    
    var selectedGoalLabel = String()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        
        view = goalOnboardingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hiddenNavigationBar()
        goalOnboardingView.setCollectionViewDataSource(dataSource: datasource)
        goalOnboardingView.setCollectionViewDelgate(delegate: self)
        setDelegate()
        planListGetAPI()
        setCollectionViewOnDataSourceUpdate()
    }
}

// MARK: - NextButtonDelegate

extension GoalOnboardingViewController: NextButtonDelegate {
    func nextButtonDidTap() {
        let howOnboardingVC = HowOnboardingViewController()
        howOnboardingVC.tempTarget = selectedGoalLabel
        self.navigationController?.pushViewController(howOnboardingVC, animated: true)
    }
}

// MARK: - Extensions

extension GoalOnboardingViewController {
    func setDelegate() {
        goalOnboardingView.delegate = self
    }
    
    func setCollectionViewOnDataSourceUpdate() {
        goalOnboardingView.onDataSourceUpdated = { [weak self] in
            self?.goalOnboardingView.setCollectionViewDataSource(dataSource: self!.datasource)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension GoalOnboardingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedGoalLabel = datasource.goalLabelList[indexPath.item].goalType
        goalOnboardingView.enableNextButton()
    }
}

extension GoalOnboardingViewController: UICollectionViewDelegateFlowLayout {
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

extension GoalOnboardingViewController {
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

