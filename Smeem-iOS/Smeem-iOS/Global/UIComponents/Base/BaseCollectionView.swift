//
//  BaseCollectionView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/10/09.
//

import UIKit

class BaseCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        setBackgroundColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setBackgroundColor() {
        backgroundColor = .smeemWhite
    }
}
