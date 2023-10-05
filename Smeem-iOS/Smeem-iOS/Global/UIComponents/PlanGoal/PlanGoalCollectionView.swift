//
//  PlanGoalCollectionView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/10/04.
//

import UIKit

enum PlanGoalType {
    case onboarding
    case myPage(target: String)
}

final class PlanGoalCollectionView: UICollectionView {
    
    // MARK: Properties
    
    private let planGoalType: PlanGoalType
    private var selectedTarget = ""
    
    var planGoalArray = [GoalPlanResponse]()
    
    // MARK: UI Properties
    
    // MARK: Life Cycle
    
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, planGoalType: PlanGoalType) {
        self.planGoalType = planGoalType
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        checkTargetString()
        registerCell()
        setBackgroundColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func checkTargetString() {
        switch planGoalType {
        case .myPage(let target):
            selectedTarget = target
        default:
            break
        }
    }
    
    private func setNextButtonState() {
        if selectedTarget != "" {
            // 버튼 활성화 시킴...
        } else {
            // 버튼 비활성화 시킴
        }
    }
    
    private func setBackgroundColor() {
        self.backgroundColor = .white
    }
    
    private func registerCell() {
        self.register(PlanGoalCollectionViewCell.self, forCellWithReuseIdentifier: PlanGoalCollectionViewCell.description())
    }
}

// MARK: - Extension : UICollectionViewDataSource

extension PlanGoalCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return planGoalArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlanGoalCollectionViewCell.description(), for: indexPath) as? PlanGoalCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
}

// MARK: - Extension : UICollectionViewDelegate

extension PlanGoalCollectionView: UICollectionViewDelegate {
    // MARK: - TODO : cellForItem 없이 해 보기
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PlanGoalCollectionViewCell else { return }
        cell.selctedCell()
        
        selectedTarget = planGoalArray[indexPath.item].goalType
        setNextButtonState()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PlanGoalCollectionViewCell else { return }
        cell.desecltedCell()
    }
}

// MARK: - Extension : UICollectionViewDelegateFlowLayout

extension PlanGoalCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: convertByHeightRatio(60))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}
