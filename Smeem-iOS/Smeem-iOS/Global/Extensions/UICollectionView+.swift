//
//  UICollectionView+.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/10/08.
//

import UIKit

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(cell: T.Type, indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError("왜? 이거 쓰면 어케 됨?")
        }
        return cell
    }
    
    func registerCell<T: UICollectionViewCell>(cell: T.Type) {
        register(cell, forCellWithReuseIdentifier: String(describing: T.self))
    }
}
