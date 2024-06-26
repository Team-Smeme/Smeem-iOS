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
    
    private var badgeHeaderData = [(name: String(), imageURL: String())]
    private var badgeListData = Array(repeating: Array(repeating: (name: String(), imageURL: String()), count: 0), count: 2)
    private var totalBadgeData = Array(repeating: Array(repeating: (name: String(), imageURL: String()), count: 4), count: 2)

    // MARK: - UI Property
    
    private let headerContainerView = UIView()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnCancelBlack, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonDidtap), for: .touchUpInside)
        return button
    }()
    
    // TODO: addTarget 넣기
    
    private lazy var badgeListTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
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
        image.image = Constant.Image.colorWelcomeBadge
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
        setDelegate()
        setRegister()
        badgeListGetAPI()
    }

    
    // MARK: - @objc
    
    @objc func cancelButtonDidtap() {
        self.navigationController?.popViewController(animated: true)
        self.presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
    
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
            $0.leading.equalToSuperview().offset(convertByHeightRatio(10))
            $0.width.height.equalTo(55)
        }
        
        badgeListTableView.snp.makeConstraints {
            $0.top.equalTo(headerContainerView.snp.bottom).offset(convertByHeightRatio(31))
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setHeaderViewLayout(headerView: UIView) {
        headerView.addSubviews(welcomeLabel, welcomeImage, detailWelcomeLabel)
        welcomeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(convertByHeightRatio(4))
            $0.leading.equalToSuperview().inset(convertByHeightRatio(24))
        }
        
        welcomeImage.snp.makeConstraints {
            $0.top.equalTo(welcomeLabel.snp.bottom).offset(convertByHeightRatio(6))
            $0.leading.equalToSuperview().inset(convertByHeightRatio(20))
            $0.width.height.equalTo(convertByHeightRatio(100))
        }
        
        detailWelcomeLabel.snp.makeConstraints {
            $0.top.equalTo(welcomeImage.snp.bottom).offset(convertByHeightRatio(8))
            $0.leading.equalToSuperview().inset(convertByHeightRatio(44))
        }
    }
}

// MARK: - UICollectionViewDelegate

extension BadgeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return convertByHeightRatio(30)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: BadgeHeaderView.identifier) as? BadgeHeaderView else { return UITableViewHeaderFooterView() }
        switch section {
        case 0:
            headerView.labelType = .diaryCount
        case 1:
            headerView.labelType = .dailyDiary
            /// ToDo: 없어도 되는지 확인
//        case 2:
//            headerView.labelType = .otherBadge
        default:
            break
        }
        return headerView
    }
}

extension BadgeListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BadgeListTableViewCell.identifier, for: indexPath) as? BadgeListTableViewCell else { return UITableViewCell() }
        cell.badgeData = self.totalBadgeData[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return constraintByNotch(convertByHeightRatio(296), 286)
    }
}

// MARK: - Network

extension BadgeListViewController {
    private func badgeListGetAPI() {
        MyPageAPI.shared.badgeListAPI() { result in
            
            switch result {
            case .success(let response):
                
                for data in response {
                    if data.badgeType == "EVENT" {
                        data.badges.forEach { badge in
                            self.badgeHeaderData = [(badge.name, badge.imageUrl)]
                        }
                    } else if data.badgeType == "COUNTING" {
                        data.badges.forEach { badge in
                            self.badgeListData[0].append((name: badge.name, imageURL: badge.imageUrl))
                        }
                    } else if data.badgeType == "COMBO" {
                        data.badges.forEach { badge  in
                            self.badgeListData[1].append((name: badge.name, imageURL: badge.imageUrl))
                        }
                    } else {
    //                    self.badgeListData[2].append((name: badge.name, imageURL: badge.imageURL))
                    }
                }
                
                self.totalBadgeData = self.badgeListData
                
                self.setHeaderViewData()
                self.badgeListTableView.reloadData()
                
            case .failure(let error):
                self.showToast(toastType: .smeemErrorToast(message: error))
            }
        }
    }
}
