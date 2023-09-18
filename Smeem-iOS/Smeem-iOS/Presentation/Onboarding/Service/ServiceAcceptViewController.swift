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
    
    private lazy var totalAcceptView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.gray100.cgColor
        view.layer.borderWidth = 1.5
        view.makeRoundCorner(cornerRadius: 6)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(totalAcceptViewDidTap))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    private lazy var checkButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnCheckInactive, for: .normal)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(totalAcceptViewDidTap), for: .touchUpInside)
        return button
    }()
    
    private let goalLabel: UILabel = {
        let label = UILabel()
        label.font = .b3
        label.text = "전체 동의하기"
        label.textColor = .gray600
        return label
    }()
    
    private let serviceCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = true
        collectionView.allowsSelection = true
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
    
    @objc func totalAcceptViewDidTap() {
        selectedTotal.toggle()
        
        if selectedTotal {
            for i in 0..<3 {
                acceptCheckArray.insert(i)
            }
            nextButton.smeemButtonType = .enabled
            goalLabel.font = .b1
            goalLabel.textColor = .point
            totalAcceptView.layer.borderColor = UIColor.point.cgColor
            totalAcceptView.layer.borderWidth = 1.5
            checkButton.setImage(Constant.Image.icnCheckActive, for: .normal)
            
            for indexPath in 0..<3 {
                serviceCollectionView.selectItem(at: IndexPath(item: indexPath, section: 0), animated: false, scrollPosition: .init())
            }
            
        } else {
            acceptCheckArray.removeAll()
            nextButton.smeemButtonType = .notEnabled
            goalLabel.font = .b3
            goalLabel.textColor = .gray600
            totalAcceptView.layer.borderColor = UIColor.gray100.cgColor
            totalAcceptView.layer.borderWidth = 1.5
            checkButton.setImage(Constant.Image.icnCheckInactive, for: .normal)
            
            for indexPath in 0..<3 {
                serviceCollectionView.deselectItem(at: IndexPath(item: indexPath, section: 0), animated: false)
            }
        }
        print(acceptCheckArray)
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
            nextButton.smeemButtonType = .enabled
        } else {
            nextButton.smeemButtonType = .notEnabled
        }
    }
    
    private func totalViewClicked() {
        if acceptCheckArray.count == 3 {
            selectedTotal.toggle()
            nextButton.smeemButtonType = .enabled
            goalLabel.font = .b1
            goalLabel.textColor = .point
            totalAcceptView.layer.borderColor = UIColor.point.cgColor
            totalAcceptView.layer.borderWidth = 1.5
            checkButton.setImage(Constant.Image.icnCheckActive, for: .normal)
        } else if acceptCheckArray.count == 0 {
            selectedTotal.toggle()
            nextButton.smeemButtonType = .notEnabled
            goalLabel.font = .b3
            goalLabel.textColor = .gray600
            totalAcceptView.layer.borderColor = UIColor.gray100.cgColor
            totalAcceptView.layer.borderWidth = 1.5
            checkButton.setImage(Constant.Image.icnCheckInactive, for: .normal)
        } else if acceptCheckArray.count < 3 {
            nextButton.smeemButtonType = .notEnabled
            goalLabel.font = .b3
            goalLabel.textColor = .gray600
            totalAcceptView.layer.borderColor = UIColor.gray100.cgColor
            totalAcceptView.layer.borderWidth = 1.5
            checkButton.setImage(Constant.Image.icnCheckInactive, for: .normal)
        }
    }
    
    // MARK: - Layout
    
    private func setBackgroundColor() {
        view.backgroundColor = .smeemWhite
    }
    
    private func setLayout() {
        view.addSubviews(titleServiceLabel, detailServiceLabel, totalAcceptView, serviceCollectionView, nextButton)
        totalAcceptView.addSubviews(checkButton, goalLabel)
        
        titleServiceLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(120)
            $0.leading.equalToSuperview().inset(26)
        }
        
        detailServiceLabel.snp.makeConstraints {
            $0.top.equalTo(titleServiceLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().inset(26)
        }
        
        totalAcceptView.snp.makeConstraints {
            $0.top.equalTo(detailServiceLabel.snp.bottom).offset(28)
            $0.trailing.leading.equalToSuperview().inset(18)
            $0.height.equalTo(60)
        }
        
        checkButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        goalLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(checkButton.snp.trailing).offset(12)
        }
        
        serviceCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.top.equalTo(totalAcceptView.snp.bottom).offset(28)
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let secondSectionItemsNumber = 3
        return secondSectionItemsNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ServiceAcceptCollectionViewCell.identifier, for: indexPath) as? ServiceAcceptCollectionViewCell else { return UICollectionViewCell() }
        cell.setData(serviceAccptArray[indexPath.item])
        
        let isSelected = acceptCheckArray.contains(indexPath.item)
        
        if isSelected {
            cell.selectedCell()
        } else {
            cell.deselectedCell()
        }
        
        cell.trainingClosure = { indexPath in
            if indexPath.item == 0 {
                if let url = URL(string: "https://smeem.notion.site/7132b91df0eb4838b435b53ad7cbb588?pvs=4") {
                    UIApplication.shared.open(url, options: [:])
                }
            } else if indexPath.item == 1 {
                if let url = URL(string: "https://smeem.notion.site/334e225bb69b45c28f31fe363ca9f25e?pvs=4") {
                    UIApplication.shared.open(url, options: [:])
                }
            } else {
                if let url = URL(string: "https://smeem.notion.site/793bae40ccd14654828b68ee41ac51b6") {
                    UIApplication.shared.open(url, options: [:])
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /// accept cell 클릭시
        if let cell = collectionView.cellForItem(at: indexPath) as? ServiceAcceptCollectionViewCell {
            let isSelected = acceptCheckArray.contains(indexPath.item)
            
            if isSelected {
                cell.deselectedCell()
                acceptDataRemove(indexPathItem: indexPath.item)
            } else {
                cell.selectedCell()
                acceptDataInsert(indexPathItem: indexPath.item)
            }
        }
        
        totalViewClicked()
        
        /// 하단 VC 버튼 활성화 로직
        checkAccptButtonType()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ServiceAcceptCollectionViewCell {
            cell.deselectedCell()
            
            /// indexPath.item에 해당하는 cell 클릭시 cell 활성화
            acceptDataRemove(indexPathItem: indexPath.item)
            
            /// 하단 VC 버튼 활성화 로직
        }
        
        totalViewClicked()
            
        checkAccptButtonType()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ServiceAcceptViewController: UICollectionViewDelegateFlowLayout {
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
