//
//  GoalOnboardingDataSource.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/08/12.
//

import UIKit

class GoalCollectionViewDataSource: NSObject {
    var goalLabelList = [TrainingGoals]()
    
    var selectedIndex: Int?
    
    func setSelectedIndex(_ index: Int) {
        selectedIndex = index
    }
}

extension GoalCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goalLabelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrainingGoalCollectionViewCell.description(), for: indexPath) as? TrainingGoalCollectionViewCell else { return UICollectionViewCell() }
        cell.setData(goalLabelList[indexPath.item].name)
        
        if indexPath.item == selectedIndex {
            cell.selctedCell()
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        }
        
        return cell
    }
}
