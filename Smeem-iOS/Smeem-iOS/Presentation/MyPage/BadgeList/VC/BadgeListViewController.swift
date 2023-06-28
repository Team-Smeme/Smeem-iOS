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
    
    private var badgeHeaderData = [(name: String(), imageURL: String())] {
        didSet {
            if !badgeHeaderData.isEmpty  {
                setHeaderViewData()
            }
        }
    }
    
    private var badgeListData = Array(repeating: Array(repeating: (name: String(), imageURL: String()), count: 0), count: 3) {
        didSet {
            setBadgeData()
        }
    }
    
    private var totalBadgeData = Array(repeating: Array(repeating: (name: String(), imageURL: String()), count: 4), count: 3)
    private var dummayBadgeData = DummyModel().dummyBadgeData()

    // MARK: - UI Property
    
    private let headerContainerView = UIView()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnCancelBlack, for: .normal)
        return button
    }()
    // TODO: addTarget 넣기
    
    private lazy var badgeListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        let welcomeHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 196))
        setHeaderViewLayout(headerView: welcomeHeaderView)
        tableView.tableHeaderView = welcomeHeaderView
        return tableView
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "웰컴 배지"
        label.font = .s1
        label.textColor = .smeemBlack
        return label
    }()
    
    private let welcomeImage: UIImageView = {
        let image = UIImageView()
        image.image = Constant.Image.eventBadgeWelcome
        return image
    }()
    
    private let detailWelcomeLabel: UILabel = {
        let label = UILabel()
        label.font = .c3
        label.textColor = .smeemBlack
        return label
    }()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        setLayout()
        hiddenNavigationBar()
        setDelegate()
        setRegister()
        badgeListGetAPI()
    }

    
    // MARK: - @objc
    
    // MARK: - Custom Method
    
    private func setDelegate() {
        badgeListTableView.delegate = self
        badgeListTableView.dataSource = self
    }
    
    private func setRegister() {
        badgeListTableView.register(BadgeListTableViewCell.self, forCellReuseIdentifier: BadgeListTableViewCell.identifier)
        badgeListTableView.register(BadgeHeaderView.self, forHeaderFooterViewReuseIdentifier: BadgeHeaderView.identifier)
    }
    
    private func setHeaderViewData() {
        let url = URL(string: badgeHeaderData[0].imageURL) ?? nil
        welcomeImage.kf.setImage(with: url)
        detailWelcomeLabel.text = badgeHeaderData[0].name
    }
    
    // 획득하지 않은 더미 배지와 획득한 서버 데이터 배지를 합쳐 주는 함수
    private func setBadgeData() {
        if !badgeListData[0].isEmpty {
            var globalIndex = 0
            for (index, (name, image)) in badgeListData[0].enumerated() {
                globalIndex = index
                totalBadgeData[0][index] = (name, image)
            }
            
            for i in globalIndex+1..<4 {
                totalBadgeData[0][i] = dummayBadgeData[0][i]
            }
        } else {
            for i in 0..<4 {
                totalBadgeData[0][i] = dummayBadgeData[0][i]
            }
        }

        if !badgeListData[1].isEmpty {
            var globalIndex = 0
            for (index, (name, image)) in badgeListData[1].enumerated() {
                globalIndex = index
                totalBadgeData[1][index] = (name, image)
            }
            for i in globalIndex+1..<4 {
                totalBadgeData[1][i] = dummayBadgeData[1][i]
            }
        } else {
            for i in 0..<4 {
                totalBadgeData[1][i] = dummayBadgeData[1][i]
            }
        }

        if !badgeListData[2].isEmpty {
            var globalIndex = 0
            for (index, (name, image)) in badgeListData[2].enumerated() {
                globalIndex = index
                totalBadgeData[2][index] = (name, image)
            }
            for i in globalIndex+1..<4 {
                totalBadgeData[2][i] = dummayBadgeData[2][i]
            }
        } else {
            for i in 0..<4 {
                totalBadgeData[2][i] = dummayBadgeData[2][i]
            }
        }
    }

    
    // MARK: - Layout
    
    private func setBackgroundColor() {
        view.backgroundColor = .smeemWhite
    }
    
    private func setLayout() {
        view.addSubviews(headerContainerView, badgeListTableView)
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
        
        badgeListTableView.snp.makeConstraints {
            $0.top.equalTo(headerContainerView.snp.bottom).offset(31)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setHeaderViewLayout(headerView: UIView) {
        headerView.addSubviews(welcomeLabel, welcomeImage, detailWelcomeLabel)
        welcomeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.leading.equalToSuperview().inset(24)
        }
        
        welcomeImage.snp.makeConstraints {
            $0.top.equalTo(welcomeLabel.snp.bottom).offset(2)
            $0.leading.equalToSuperview().inset(20)
            $0.width.height.equalTo(100)
        }
        
        detailWelcomeLabel.snp.makeConstraints {
            $0.top.equalTo(welcomeImage.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(44)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension BadgeListViewController: UITableViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if indexPath.section == 0 {
//            return CGSize(width: convertByWidthRatio(375), height: convertByHeightRatio(130))
//        } else {
//            return CGSize(width: convertByWidthRatio(375), height: convertByHeightRatio(276))
//        }
//    }
//
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: BadgeHeaderView.identifier) as? BadgeHeaderView else { return UITableViewHeaderFooterView() }
        switch section {
        case 0:
            headerView.labelType = .diaryCount
        case 1:
            headerView.labelType = .dailyDiary
        case 2:
            headerView.labelType = .otherBadge
        default:
            break
        }
        return headerView
    }
}

extension BadgeListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BadgeListTableViewCell.identifier, for: indexPath) as? BadgeListTableViewCell else { return UITableViewCell() }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            cell.badgeData = self.totalBadgeData[indexPath.section]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return convertByHeightRatio(276)
    }
}

// MARK: - Network

extension BadgeListViewController {
    private func badgeListGetAPI() {
        MyPageAPI.shared.badgeListAPI() { response in
            guard let badges = response?.data?.badges else { return }
            
            // 섹션에 따라 배열 데이터 담는 로직
            for badge in badges {
                if badge.type == "EVENT" {
                    self.badgeHeaderData = [(badge.name, badge.imageURL)]
                } else if badge.type == "COUNTING" {
                    self.badgeListData[0].append((name: badge.name, imageURL: badge.imageURL))
                } else if badge.type == "COMBO" {
                    self.badgeListData[1].append((name: badge.name, imageURL: badge.imageURL))
                } else {
                    self.badgeListData[2].append((name: badge.name, imageURL: badge.imageURL))
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
