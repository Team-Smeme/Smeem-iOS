//
//  MyPlanCollectionViewLayout.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 4/29/24.
//

import UIKit

final class MyPlanCollectionViewLayout: NSObject, UICollectionViewDelegateFlowLayout {
    
    private var cellNumber: Int
    
    init(cellCount: Int) {
        self.cellNumber = cellCount
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let leadingTrailingInset = 73.0
            let itemSpacing = 162.0
            let cellCount = 7.0
            return CGSize(width: (UIScreen.main.bounds.width-(leadingTrailingInset+itemSpacing))/cellCount,
                          height: (UIScreen.main.bounds.width-(leadingTrailingInset+itemSpacing))/cellCount)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch cellNumber {
        case 1:
            return 0.0
        case 3:
            return 112.0
        case 5:
            return 46.0
        case 7:
            return 27.0
        default:
            return 0.0
        }
    }
}
