//
//  BadgeListCollectionViewCell.swift
//  Smeem-iOS
//
//  Created by JH on 2023/06/28.
//

import UIKit

final class BadgeListTableViewCell: UITableViewCell {
    
    // MARK: - Property
    
    static let identifier = "BadgeListTableViewCell"
    
    var badgeData = Array(repeating: (name: String(), imageURL: String()), count: 0) {
        didSet {
            detailBadgeCollectionView.reloadData()
        }
    }
    
    // MARK: - UI Property
    
    private lazy var detailBadgeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setDelegate()
        setRegister()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - @objc
    // MARK: - Custom Method
    
    private func setDelegate() {
        detailBadgeCollectionView.delegate = self
        detailBadgeCollectionView.dataSource = self
    }
    
    private func setRegister() {
        detailBadgeCollectionView.register(DetailBadgeCollectionViewCell.self, forCellWithReuseIdentifier: DetailBadgeCollectionViewCell.identifier)
    }
//    }
    
    // MARK: - Layout
    
    private func setLayout() {
        addSubviews(detailBadgeCollectionView)
        
        detailBadgeCollectionView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - UITableView Delegate
}

extension BadgeListTableViewCell: UICollectionViewDelegate {

}

extension BadgeListTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {        
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailBadgeCollectionViewCell.identifier, for: indexPath) as? DetailBadgeCollectionViewCell else { return UICollectionViewCell() }
            cell.setdummyData(dummy: (self.badgeData[indexPath.row].name, self.badgeData[indexPath.row].imageURL))
        return cell
    }
}

extension BadgeListTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: convertByWidthRatio(100), height: convertByHeightRatio(128))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return constraintByNotch(14, 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 6, left: 20, bottom: 0, right: 31)
    }
}
