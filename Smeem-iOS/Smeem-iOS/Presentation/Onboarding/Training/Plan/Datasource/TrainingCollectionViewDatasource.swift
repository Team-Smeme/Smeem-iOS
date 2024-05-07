//
//  TrainingCollectionViewDatasource.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 5/1/24.
//

import UIKit

final class TrainingCollectionViewDatasource: NSObject, UICollectionViewDataSource {
    
    private let trainingItems: [Plans]
    
    init(trainingItems: [Plans]) {
        self.trainingItems = trainingItems
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.trainingItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: TrainingCollectionViewCell.self,
                                                      indexPath: indexPath)
        cell.setData(trainingItems[indexPath.item].content)
        return cell
    }
}
