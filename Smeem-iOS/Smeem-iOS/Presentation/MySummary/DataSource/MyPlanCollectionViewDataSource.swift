//
//  MyPlanCollectionViewDataSource.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 4/29/24.
//

import UIKit

final class MyPlanCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    private let planNumber: Int
    private var totalNumber: [Int]
    
    init(planNumber: Int, totalNumber: [Int]) {
        self.planNumber = planNumber
        self.totalNumber = totalNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.totalNumber.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: MyPlanCollectionViewCell.self,
                                                      indexPath: indexPath)
        
        cell.setNumberData(text: String(totalNumber[indexPath.item]))
        indexPath.item < planNumber ? cell.activateCell() : cell.deactivateCell()
        
        return cell
    }
}
