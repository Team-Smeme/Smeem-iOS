//
//  ServiceAcceptViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/17.
//

import UIKit

final class ServiceAcceptViewController: UIViewController {
    
    // MARK: - Property
    
    let serviceAccptArray = ["[필수] 서비스 이용약관", "[필수] 개인정보 수집 및 이용 동의",
                             "[필수] 위치기반 서비스 이용약관 동의", "[선택] 마케팅 정보 활용 동의"]
    
    // MARK: - UI Property
    
    private let titleServiceLabel: UILabel = {
        let label = UILabel()
        label.text = "서비스 이용약관"
        label.font = .h2
        label.textColor = .smeemBlack
        return label
    }()
    
    private let detailServiceLabel: UILabel = {
        let label = UILabel()
        label.text = "서비스 이용을 위해 약관에 동의해주세요."
        label.font = .b4
        label.textColor = .smeemBlack
        return label
    }()
    
    private let serviceCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()
    
    private let nextButton: SmeemButton = {
        let button = SmeemButton()
        button.setTitle("다음", for: .normal)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        setLayout()
        setDelegate()
        setCellRegister()
    }
    
    // MARK: - @objc
    
    // MARK: - Custom Method
    
    private func setDelegate() {
        serviceCollectionView.delegate = self
        serviceCollectionView.dataSource = self
    }
    
    private func setCellRegister() {
        serviceCollectionView.register(GoalCollectionViewCell.self, forCellWithReuseIdentifier: GoalCollectionViewCell.identifier)
        serviceCollectionView.register(ServiceAcceptCollectionViewCell.self, forCellWithReuseIdentifier: ServiceAcceptCollectionViewCell.identifier)
    }
    
    // MARK: - Layout
    
    private func setBackgroundColor() {
        view.backgroundColor = .smeemWhite
    }
    
    private func setLayout() {
        view.addSubviews(titleServiceLabel, detailServiceLabel, serviceCollectionView, nextButton)
        
        titleServiceLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(120)
            $0.leading.equalToSuperview().inset(26)
        }
        
        detailServiceLabel.snp.makeConstraints {
            $0.top.equalTo(titleServiceLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().inset(26)
        }
        
        serviceCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.top.equalTo(detailServiceLabel.snp.bottom).offset(28)
            $0.bottom.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(50)
            $0.height.equalTo(convertByHeightRatio(60))
        }
    }
}

// MARK: - UICollectionViewDelegate

extension ServiceAcceptViewController: UICollectionViewDelegate { }

// MARK: - UICollectionViewDataSource

extension ServiceAcceptViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let sectionNumber = 2
        return sectionNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let firstSectionItemsNumber = 1
        let secondSectionItemsNumber = 4
        
        if section == 0 {
            return firstSectionItemsNumber
        } else {
            return secondSectionItemsNumber
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalCollectionViewCell.identifier, for: indexPath) as? GoalCollectionViewCell else { return UICollectionViewCell() }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ServiceAcceptCollectionViewCell.identifier, for: indexPath) as? ServiceAcceptCollectionViewCell else { return UICollectionViewCell() }
            cell.setData(serviceAccptArray[indexPath.item])
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ServiceAcceptViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let width = collectionView.frame.width
            let height = convertByHeightRatio(60)
            return CGSize(width: width, height: height)
        } else {
            let width = collectionView.frame.width
            let height = convertByHeightRatio(20)
            return CGSize(width: width, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 1 {
            let sectionLineSpacing: CGFloat = 32
            return sectionLineSpacing
        }
        return CGFloat()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 1 {
            return UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0)
        }
        return UIEdgeInsets()
    }
}
