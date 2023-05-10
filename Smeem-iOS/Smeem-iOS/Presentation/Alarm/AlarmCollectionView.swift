//
//  AlarmCollectionView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/10.
//

import UIKit

final class AlarmCollectionView: UICollectionView {
    
    // MARK: - Property
    
    let dayArray = ["월", "화", "수", "목", "금", "토", "일"]
    let selectedIndexPath: [IndexPath] = [IndexPath(item: 0, section: 0), IndexPath(item: 1, section: 0), IndexPath(item: 2, section: 0), IndexPath(item: 3, section: 0), IndexPath(item: 4, section: 0)]
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        setBackgroundColor()
        setProperty()
        setDelegate()
        setCellRegister()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - @objc
    
    // MARK: - Custom Method
    
    private func setBackgroundColor() {
        backgroundColor = .clear
    }
    
    private func setProperty() {
        showsHorizontalScrollIndicator = false
        allowsMultipleSelection = true
    }
    
    private func setDelegate() {
        self.delegate = self
        self.dataSource = self
    }
    
    private func setCellRegister() {
        self.register(AlarmCollectionViewCell.self, forCellWithReuseIdentifier: AlarmCollectionViewCell.identifier)
    }
}

// MARK: - UICollectionViewDelegate

extension AlarmCollectionView: UICollectionViewDelegate {

}

// MARK: - UICollectionViewDataSource

extension AlarmCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  AlarmCollectionViewCell.identifier, for: indexPath) as? AlarmCollectionViewCell else { return UICollectionViewCell() }
        
        let initalSelectedIndexPaths = selectedIndexPath
        initalSelectedIndexPaths.forEach {
            collectionView.selectItem(at: $0, animated: false, scrollPosition: .init())
        }
        
        if indexPath.item == 0 {
            cell.makeSelectedRoundCorners(cornerRadius: 6, maskedCorners: .layerMinXMinYCorner)
        } else if indexPath.row == dayArray.count-1 {
            cell.makeSelectedRoundCorners(cornerRadius: 6, maskedCorners: .layerMaxXMinYCorner)
        }
        cell.setData(dayArray[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AlarmCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: convertByWidthRatio(46), height: convertByHeightRatio(49))
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
