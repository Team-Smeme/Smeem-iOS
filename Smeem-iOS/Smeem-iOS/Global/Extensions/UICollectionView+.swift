//
//  UICollectionView+.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/10/08.
//

import UIKit

extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(cell: T.Type) {
        register(cell, forCellWithReuseIdentifier: T.className)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(cell: T.Type, indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.className, for: indexPath) as? T else {
            fatalError("Could not dequeue cell for type: \(T.self)")
        }
        return cell
    }
}
