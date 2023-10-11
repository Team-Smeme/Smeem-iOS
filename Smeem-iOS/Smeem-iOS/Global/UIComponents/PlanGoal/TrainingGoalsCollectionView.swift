//
//  PlanGoalCollectionView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/10/04.
//

import UIKit

enum TrainingGoalsType {
    case onboarding
    case myPage(target: String)
}

final class TrainingGoalsCollectionView: BaseCollectionView {
    
    // MARK: Properties
    
    var trainingDelegate: TrainingDataSendDelegate?

    private var selectedTarget = ""
    var planGoalArray = [TrainingGoals]() {
        didSet {
            self.reloadData()
        }
    }
    
    // MARK: UI Properties
    
    // MARK: Life Cycle
    
    init(planGoalType: TrainingGoalsType) {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

        checkTargetString(planGoalType: planGoalType)
        registerCell()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func checkTargetString(planGoalType: TrainingGoalsType) {
        switch planGoalType {
        case .myPage(let target):
            selectedTarget = target
        default:
            break
        }
    }
    
    private func setNextButtonState() {
        trainingDelegate?.sendButtonState()
    }
    
    private func registerCell() {
        self.registerCell(cell: TrainingGoalCollectionViewCell.self)
    }
    
    private func setDelegate() {
        self.delegate = self
        self.dataSource = self
    }
}

// MARK: - Extension : UICollectionViewDataSource

extension TrainingGoalsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return planGoalArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(cell: TrainingGoalCollectionViewCell.self, indexPath: indexPath)
        cell.setData(planGoalArray[indexPath.item].name)
        return cell
    }
}

// MARK: - Extension : UICollectionViewDelegate

extension TrainingGoalsCollectionView: UICollectionViewDelegate {
    // MARK: - TODO : cellForItem 없이 해 보기
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrainingGoalCollectionViewCell else { return }
        cell.selctedCell()
        
        selectedTarget = planGoalArray[indexPath.item].goalType
        
        trainingDelegate?.sendTargetString(targetString: selectedTarget)
        trainingDelegate?.sendButtonState()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrainingGoalCollectionViewCell else { return }
        cell.desecltedCell()
    }
}

// MARK: - Extension : UICollectionViewDelegateFlowLayout

extension TrainingGoalsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellInset: CGFloat = 18
        return CGSize(width: self.frame.width-(cellInset*2), height: convertByHeightRatio(60))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}
