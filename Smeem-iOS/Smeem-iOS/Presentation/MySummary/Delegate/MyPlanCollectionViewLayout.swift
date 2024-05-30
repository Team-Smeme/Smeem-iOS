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
            return CGSize(width: 20, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch cellNumber {
        case 1:
            return 0.0
        case 3:
            return (21.0 / 375) * UIScreen.main.bounds.width
        case 5:
            return (46.0 / 375) * UIScreen.main.bounds.width
        case 7:
            return (27.0 / 375) * UIScreen.main.bounds.width
        default:
            return 0.0
        }
    }
}
