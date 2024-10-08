//
//  PlanGoalCollectionView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/10/04.
//

import UIKit

enum TrainingGoalsType: Equatable {
    case onboarding
    case myPage(targetIndex: Int)
    case resign
}

protocol TrainingDataSendDelegate {
    func sendTargetData(targetString: String, buttonType: SmeemButtonType)
}

protocol ResignSummaryDataSendDelegate {
    func sendTargetData(summaryInt: Int)
}

final class TrainingGoalsCollectionView: BaseCollectionView {
    
    // MARK: Properties
    
    var trainingDelegate: TrainingDataSendDelegate?
    var resignSummaryDelegate: ResignSummaryDataSendDelegate?

    private var selectedTarget = ""
    private var selectedIndex = -1
    private var cellType = TrainingGoalsType.resign
    var planGoalArray = [Goal]()
    
    // MARK: UI Properties
    
    // MARK: Life Cycle
    
    init(planGoalType: TrainingGoalsType) {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        self.cellType = planGoalType
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
            selectedIndex = target
        default:
            break
        }
    }
    
    private func registerCell() {
        self.registerCell(cellType: TrainingCollectionViewCell.self)
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
        let cell = dequeueReusableCell(cellType: TrainingCollectionViewCell.self, indexPath: indexPath)
        cell.setData(planGoalArray[indexPath.item].name)
        
        if selectedIndex != -1 && indexPath.item == selectedIndex {
            cell.selctedCell()
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        } else {
            cell.desecltedCell()
        }
        
        return cell
    }
}

// MARK: - Extension : UICollectionViewDelegate

extension TrainingGoalsCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrainingCollectionViewCell else { return }
        cell.selctedCell()
        
        selectedIndex = indexPath.item
        if let goalType = planGoalArray[indexPath.item].goalType {
            selectedTarget = goalType
        }
        
        trainingDelegate?.sendTargetData(targetString: selectedTarget, buttonType: .enabled)
        resignSummaryDelegate?.sendTargetData(summaryInt: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrainingCollectionViewCell else { return }
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
        return self.cellType == .resign ? 5 : 12
    }
}
