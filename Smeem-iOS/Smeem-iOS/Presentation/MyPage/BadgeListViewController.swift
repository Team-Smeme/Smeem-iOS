//
//  BadgeViewController.swift
//  Smeem-iOS
//
//  Created by JH on 2023/06/07.
//

import UIKit

import Kingfisher
import SnapKit

class BadgeListViewController: UIViewController {
    // MARK: - Property
    
    struct BadgeModel {
        let badgeImage: String
        let badgeName: String
    }
    
    var badgeList: [BadgeModel] = [
        BadgeModel(badgeImage: "url", badgeName: "웰컴 배지")
    ]
    
    // MARK: - UI Property
    
    private let headerContainerView = UIView()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnCancelBlack, for: .normal)
        return button
    }()
    // TODO: addTarget 넣기
    
    private lazy var badgeListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var firstSectionCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        setLayout()
        hiddenNavigationBar()
        setDelegate()
        setRegister()
    }

    
    // MARK: - @objc
    
    // MARK: - Custom Method
    
    private func setDelegate() {
        badgeListCollectionView.delegate = self
        badgeListCollectionView.dataSource = self
    }
    
    private func setRegister() {
        badgeListCollectionView.register(BadgeListCollectionViewCell.self, forCellWithReuseIdentifier: BadgeListCollectionViewCell.identifier)
        badgeListCollectionView.register(BadgeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BadgeHeaderView.identifier)
    }

    
    // MARK: - Layout
    
    private func setBackgroundColor() {
        view.backgroundColor = .smeemWhite
    }
    
    private func setLayout() {
        view.addSubviews(headerContainerView, badgeListCollectionView)
        headerContainerView.addSubview(cancelButton)
        
        headerContainerView.snp.makeConstraints{
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(convertByHeightRatio(66))
        }
        
        cancelButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.height.equalTo(45)
        }
        
        badgeListCollectionView.snp.makeConstraints {
            $0.top.equalTo(headerContainerView.snp.bottom).offset(31)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegate

extension BadgeListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: convertByWidthRatio(375), height: convertByHeightRatio(130))
        } else {
            return CGSize(width: convertByWidthRatio(375), height: convertByHeightRatio(276))
        }
    }
}

extension BadgeListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BadgeListCollectionViewCell.identifier, for: indexPath) as? BadgeListCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
}

extension BadgeListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: convertByWidthRatio(375), height: convertByHeightRatio(30))
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BadgeHeaderView.identifier, for: indexPath) as? BadgeHeaderView else { return UICollectionReusableView() }
        switch indexPath.section {
        case 0:
            headerView.labelType = .welcome
        case 1:
            headerView.labelType = .diaryCount
        case 2:
            headerView.labelType = .dailyDiary
        case 3:
            headerView.labelType = .otherBadge
        default:
            break
        }
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 36, right: 0)
    }
}

// MARK: - UICollectionViewDataSource
