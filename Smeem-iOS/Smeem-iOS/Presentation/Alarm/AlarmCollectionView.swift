//
//  AlarmCollectionView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/10.
//

/**
 1. 사용할 VC에서 AlarmCollectionView 프로퍼티 생성
 private lazy var alarm = AlarmCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
 
 2. view에 addSubView 하고 레이아웃 값 준 후 사용
 */

import UIKit

final class AlarmCollectionView: UICollectionView {
    
    // MARK: - Property
    
    private let dayArray = ["월", "화", "수", "목", "금", "토", "일"]
    private let selectedIndexPath = [IndexPath(item: 0, section: 0), IndexPath(item: 1, section: 0), IndexPath(item: 2, section: 0), IndexPath(item: 3, section: 0), IndexPath(item: 4, section: 0)]
    
    // MARK: - UI Property
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        setBackgroundColor()
        setProperty()
        setDelegate()
        setCellRegister()
        setViewRegister()
        setLayerUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - @objc
    
    // MARK: - Custom Method
    
    private func setBackgroundColor() {
        backgroundColor = .clear
    }
    
    private func setLayerUI() {
        makeRoundCorner(cornerRadius: 6)
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.gray100.cgColor
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
    
    private func setViewRegister() {
        self.register(DatePickerFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: DatePickerFooterView.identifier)
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
        cell.setData(dayArray[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AlarmCollectionView: UICollectionViewDelegateFlowLayout {
    // (cell size, itemSpacing)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: convertByWidthRatio(46), height: convertByHeightRatio(49))
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // footer
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let footerSize = CGSize(width: collectionView.bounds.width, height: convertByHeightRatio(84))
        return footerSize
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DatePickerFooterView.identifier, for: indexPath) as? DatePickerFooterView else { return UICollectionReusableView() }
        return footerView
    }
}
