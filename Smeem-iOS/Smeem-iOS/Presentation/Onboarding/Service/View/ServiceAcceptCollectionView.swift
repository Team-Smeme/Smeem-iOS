//
//  ServiceAcceptCollectionView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2024/02/08.
//

import UIKit

protocol ServiceAcceptProtocol {
    func selectedCellDataSend(indexPath: Int)
    func deselectedCellDataSend(indexPath: Int)
    func cellIndexDataSend(indexPath: Int)
}

final class ServiceAcceptCollectionView: UICollectionView {
    
    var serviceAcceptProtocol: ServiceAcceptProtocol?
    
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        self.backgroundColor = .clear
        self.showsVerticalScrollIndicator = false
        self.allowsMultipleSelection = true
        self.allowsSelection = true
        
        setDelegate()
        setCellRegister()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setDelegate() {
        self.delegate = self
        self.dataSource = self
    }
    
    private func setCellRegister() {
        self.register(ServiceAcceptCollectionViewCell.self, forCellWithReuseIdentifier: ServiceAcceptCollectionViewCell.identifier)
    }
}

// MARK: Delegate

extension ServiceAcceptCollectionView: CellProtocol {
    func cellIndexDataSend(indexPath: Int) {
        serviceAcceptProtocol?.cellIndexDataSend(indexPath: indexPath)
    }
}

extension ServiceAcceptCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let secondSectionItemsNumber = 3
        return secondSectionItemsNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ServiceAcceptCollectionViewCell.identifier, for: indexPath) as? ServiceAcceptCollectionViewCell else { return UICollectionViewCell() }
        cell.setData(ServiceAcceptAppData.array[indexPath.item])
        cell.cellProtocol = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        serviceAcceptProtocol?.selectedCellDataSend(indexPath: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        serviceAcceptProtocol?.deselectedCellDataSend(indexPath: indexPath.item)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ServiceAcceptCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = convertByHeightRatio(45)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let sectionLineSpacing: CGFloat = 5
        return sectionLineSpacing
    }
}

