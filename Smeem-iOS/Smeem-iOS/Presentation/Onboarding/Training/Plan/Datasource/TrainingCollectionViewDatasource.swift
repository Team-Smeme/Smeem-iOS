//
//  TrainingCollectionViewDatasource.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 5/1/24.
//

import UIKit

final class TrainingCollectionViewDatasource: NSObject, UICollectionViewDataSource {
    
    private let trainingItems: [Plans]
    private let selectedPlan: Int?
    
    init(trainingItems: [Plans], selectedPlan: Int? = nil) {
        self.trainingItems = trainingItems
        self.selectedPlan = selectedPlan
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.trainingItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: TrainingCollectionViewCell.self,
                                                      indexPath: indexPath)
        cell.setData(trainingItems[indexPath.item].content)
        
        if selectedPlan != nil && indexPath.item+1 == selectedPlan {
            cell.selctedCell()
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
        } else {
            cell.desecltedCell()
        }
        
        return cell
    }
}
