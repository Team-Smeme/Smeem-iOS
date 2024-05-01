//
//  MySmeemCollectionViewDataSource.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 4/29/24.
//

import UIKit

final class MySmeemCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    private let numberItems: [Int]
    private let textItems: [String]
    
    init(numberItems: [Int], textItems: [String]) {
        self.numberItems = numberItems
        self.textItems = textItems
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: MySmeemCollectionViewCell.self, indexPath: indexPath)
        cell.setNumberData(number: self.numberItems[indexPath.item])
        cell.setTextData(text: self.textItems[indexPath.item])
        return cell
    }
}
