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
        let cell = collectionView.dequeueReusableCell(cellType: MyBadgeCollectionViewCell.self, indexPath: indexPath)

        if badgeData[indexPath.item].hasBadge {
            cell.setBadgeLayout()
            cell.setBadgeData(data: (badgeData[indexPath.item].name,
                                     badgeData[indexPath.item].imageUrl))
        } else {
            cell.setLayout()
        }
        
        return cell
    }
}
