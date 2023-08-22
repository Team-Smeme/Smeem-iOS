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
                             "[선택] 마케팅 정보 활용 동의"]
    var acceptCheckArray: Set<Int> = [] {
        didSet {
            checkAccptButtonType()
        }
    }
    var nickNameData = ""
    private var notiAccessToken = ""

    private var selectedTotal = false {
        didSet {
            serviceCollectionView.reloadData()
        }
    }
    
//    private var acceptCheckArray = [] {
//        didSet {
//            checkAccptButtonType()
//        }
//    }
    
    // MARK: - UI Property
    
    private let loadingView = LoadingView()
    
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
    
    private lazy var nextButton: SmeemButton = {
        let button = SmeemButton()
        button.smeemButtonType = .notEnabled
        button.setTitle("다음", for: .normal)
        button.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
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
    
    @objc func nextButtonDidTap() {
        showLodingView(loadingView: loadingView)
        nicknamePatchAPI()
    }
    
    // MARK: - Custom Method
    
    private func setDelegate() {
        serviceCollectionView.delegate = self
        serviceCollectionView.dataSource = self
    }
    
    private func setCellRegister() {
        serviceCollectionView.register(ServiceAcceptTotalCollectionViewCell.self, forCellWithReuseIdentifier: ServiceAcceptTotalCollectionViewCell.identifier)
        serviceCollectionView.register(ServiceAcceptCollectionViewCell.self, forCellWithReuseIdentifier: ServiceAcceptCollectionViewCell.identifier)
    }
    
    private func acceptDataInsert(indexPathItem: Int) {
        acceptCheckArray.insert(indexPathItem)
    }
    
    private func acceptDataRemove(indexPathItem: Int) {
        acceptCheckArray.remove(indexPathItem)
    }
    
    private func checkAccptButtonType() {
       if acceptCheckArray.contains(0) && acceptCheckArray.contains(1) {
           
//           self.serviceCollectionView.reloadData()
            nextButton.smeemButtonType = .enabled
        } else {
//            self.serviceCollectionView.reloadData()
            nextButton.smeemButtonType = .notEnabled
        }
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

// MARK: - Network

extension ServiceAcceptViewController {
    private func nicknamePatchAPI() {
        OnboardingAPI.shared.serviceAcceptedPatch(param: ServiceAcceptRequest(username: nickNameData,
                                                                              termAccepted: true),
                                                  accessToken: UserDefaultsManager.clientAccessToken) { response in
            guard let data = response.data else { return }
            
            // 성공했을 때 UserDefaults에 저장
            UserDefaultsManager.accessToken = UserDefaultsManager.clientAccessToken
            UserDefaultsManager.refreshToken = UserDefaultsManager.clientRefreshToken
            
            let homeVC = HomeViewController()
            homeVC.badgePopupData = data.badges
            self.changeRootViewController(homeVC)
            
            self.hideLodingView(loadingView: self.loadingView)
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
        let secondSectionItemsNumber = 3
        
        if section == 0 {
            return firstSectionItemsNumber
        } else {
            return secondSectionItemsNumber
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ServiceAcceptTotalCollectionViewCell.identifier, for: indexPath) as? ServiceAcceptTotalCollectionViewCell else { return UICollectionViewCell() }
            cell.selectedCell = selectedTotal
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ServiceAcceptCollectionViewCell.identifier, for: indexPath) as? ServiceAcceptCollectionViewCell else { return UICollectionViewCell() }
            cell.setData(serviceAccptArray[indexPath.item])
            cell.checkTotal = selectedTotal
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectedTotal.toggle()
            if selectedTotal {
                acceptCheckArray = [0, 1, 2]
                collectionView.reloadData()
                nextButton.smeemButtonType = .enabled
            } else {
                acceptCheckArray.removeAll()
                collectionView.reloadData()
                nextButton.smeemButtonType = .notEnabled
            }
        } else if indexPath.section == 1 {
            /// accept cell 클릭시
            if let cell = collectionView.cellForItem(at: indexPath) as? ServiceAcceptCollectionViewCell {
                cell.checkTotal.toggle()
                
                /// indexPath.item에 해당하는 cell 클릭시 cell 활성화
                acceptDataInsert(indexPathItem: indexPath.item)
            }
            
//            if !selectedTotal && acceptCheckArray.count == 3 {
//                selectedTotal.toggle()
//                if selectedTotal {
//                    collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
//                } else {
//                    collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
//                }
//            }
            
            /// 하단 VC 버튼 활성화 로직
            checkAccptButtonType()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ServiceAcceptCollectionViewCell {
            cell.checkTotal.toggle()
        }

        /// indexPath.item에 해당하는 cell 클릭시 cell 활성화
        acceptDataRemove(indexPathItem: indexPath.item)
        
        /// 하단 VC 버튼 활성화 로직
        checkAccptButtonType()
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
