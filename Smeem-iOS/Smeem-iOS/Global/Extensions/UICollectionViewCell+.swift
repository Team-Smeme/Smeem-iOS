//
//  UICollectionView+.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/08/06.
//

import UIKit

extension UICollectionViewCell {
    func getIndexPath() -> IndexPath? {
        guard let superView = self.superview as? UICollectionView else { return nil }
        return superView.indexPath(for: self)
    }
}
