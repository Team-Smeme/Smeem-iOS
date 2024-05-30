//
//  MyBadgeCollectionViewDatasource.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 5/6/24.
//

import UIKit

final class MyBadgeCollectionViewDatasource: NSObject, UICollectionViewDataSource {
    
    private let badgeData: [MySummaryBadgeResponse]
    
    init(badgeData: [MySummaryBadgeResponse]) {
        self.badgeData = badgeData
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 획득한 뱃지일 경우
        if badgeData[indexPath.item].hasBadge {
            let cell = collectionView.dequeueReusableCell(cellType: MyBadgeCollectionViewCell.self, indexPath: indexPath)
            
            cell.setBadgeLayout()
            cell.setBadgeData(data: (badgeData[indexPath.item].name,
                                     badgeData[indexPath.item].imageUrl))
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(cellType: LockBadgeCollectionViewCell.self, indexPath: indexPath)
            
            cell.setLayout()
            return cell
        }
    }
}
