//
//  GoalOnboardingDataSource.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/08/12.
//

import UIKit

class GoalOnboardingDataSource: NSObject {
    var goalLabelList = [Plan]()
}

extension GoalOnboardingDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goalLabelList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalCollectionViewCell.identifier, for: indexPath) as? GoalCollectionViewCell else { return UICollectionViewCell() }
        cell.setData(goalLabelList[indexPath.item].name)
        return cell
    }
}
