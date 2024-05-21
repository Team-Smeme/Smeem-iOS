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
        if indexPath.item < planNumber {
            let cell = collectionView.dequeueReusableCell(cellType: MyPlanActiveCollectionViewCell.self,
                                                          indexPath: indexPath)
            
            cell.setNumberData(text: String(totalNumber[indexPath.item]))
            cell.activateCell()
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(cellType: MyPlanDeactiveCollectionViewCell.self,
                                                          indexPath: indexPath)
            
            cell.setNumberData(text: String(totalNumber[indexPath.item]))
            cell.deactivateCell()
            
            return cell
        }
    }
}
