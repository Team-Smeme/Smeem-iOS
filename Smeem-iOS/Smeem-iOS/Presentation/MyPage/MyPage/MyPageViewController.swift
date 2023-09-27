//
//  MyPageViewController.swift
//  Smeem-iOS
//
//  Created by 임주민 on 2023/06/27.
//

import UIKit

import SnapKit

final class MyPageViewController: UIViewController {
    
    // MARK: - Property
    
    private let mypageManager: MyPageManager
    private let editPushManager: MyPageEditManager
    
    private var userInfo = MyPageResponse(username: "", target: "", way: "", detail: "", targetLang: "", hasPushAlarm: true, trainingTime: TrainingTime(day: "", hour: 0, minute: 0), badge: Badge(id: 0, name: "", type: "", imageURL: ""))
    var myPageSelectedIndexPath = ["MON": IndexPath(item: 0, section: 0), "TUE":IndexPath(item: 1, section: 0), "WED":IndexPath(item: 2, section: 0), "THU":IndexPath(item: 3, section: 0), "FRI":IndexPath(item: 4, section: 0), "SAT":IndexPath(item: 5, section: 0), "SUN":IndexPath(item: 6, section: 0)]
    var indexPathArray: [IndexPath] = []
    var hasAlarm = Bool()
    
    var onTargetRecived: ((_ target: String) -> Void)?
    
    let goalTextToIndex: [String: (Int, String)] = [
        "자기계발": (0, "DEVELOP"),
        "취미로 즐기기": (1, "HOBBY"),
        "현지 언어 체득": (2, "APPLY"),
        "유창한 비즈니스 영어": (3, "BUSINESS"),
        "어학 시험 고득점": (4, "EXAM"),
        "아직 모르겠어요": (5, "NONE")
    ]
    
    var toastMessageFlag = false {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.loadToastMessage()
            }
        }
    }
    
    // MARK: - UI Property
    
    private let headerContainerView = UIView()
    private let contentView = UIView()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnBack, for: .normal)
        button.addTarget(self, action: #selector(backButtonDidTap(_:)), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "마이페이지"
        label.font = .s2
        label.textColor = .smeemBlack
        return label
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnMoreMono, for: .normal)
        button.addTarget(self, action: #selector(moreButtonDidTap(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let nickNameLabel = UILabel()
        nickNameLabel.font = .h3
        nickNameLabel.textColor = .smeemBlack
        return nickNameLabel
    }()
    
    private lazy var editButton: UIButton = {
        let editButton = UIButton()
        editButton.setImage(Constant.Image.icnPencil, for: .normal)
        editButton.addTarget(self, action: #selector(editButtonDidTap(_:)), for: .touchUpInside)
        return editButton
    }()
    
    private let howLearningView: HowLearningView = {
        let view = HowLearningView()
        view.buttontype = .logo
        return view
    }()
    
    private let badgeLabel: UILabel = {
        let badgeLabel = UILabel()
        badgeLabel.text = "내 배지"
        badgeLabel.font = .s1
        badgeLabel.textColor = .smeemBlack
        return badgeLabel
    }()
    
    private lazy var badgeContainer: UIView = {
        let badgeContainer = UIView()
        badgeContainer.backgroundColor = .clear
        badgeContainer.layer.borderWidth = 1.5
        badgeContainer.layer.borderColor = UIColor.gray100.cgColor
        badgeContainer.makeRoundCorner(cornerRadius: 6)
        return badgeContainer
    }()
    
    private lazy var badgeImage: UIImageView = {
        let image = UIImageView()
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(badgeImageDidTap)))
        image.isUserInteractionEnabled = true
        return image
    }()
    
    private let badgeMoreButton: UIImageView = {
        let image = UIImageView()
        image.image = Constant.Image.icnForward
        return image
    }()
    
    private let badgeNameLabel: UILabel = {
        let badgeNameLabel = UILabel()
        badgeNameLabel.text = "웰컴 배지"
        badgeNameLabel.font = .b1
        badgeNameLabel.textColor = .smeemBlack
        return badgeNameLabel
    }()
    
    private let badgeSummaryLabel: UILabel = {
        let badgeSummaryLabel = UILabel()
        badgeSummaryLabel.font = .b4
        badgeSummaryLabel.textColor = .gray600
        return badgeSummaryLabel
    }()
    
    private let languageLabel: UILabel = {
        let languageLabel = UILabel()
        languageLabel.text = "학습 언어"
        languageLabel.font = .s1
        languageLabel.textColor = .smeemBlack
        return languageLabel
    }()
    
    private let languageContainer: UIView = {
        let languageContainer = UIView()
        languageContainer.backgroundColor = .clear
        languageContainer.layer.borderWidth = 1.5
        languageContainer.layer.borderColor = UIColor.gray100.cgColor
        languageContainer.makeRoundCorner(cornerRadius: 6)
        return languageContainer
    }()
    
    private let languageLabelEnglish: UILabel = {
        let languageLabel = UILabel()
        languageLabel.text = "English"
        languageLabel.font = .b4
        languageLabel.textColor = .smeemBlack
        return languageLabel
    }()
    
    private let languageCheckButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnCheck, for: .normal)
        return button
    }()
    
    private let alarmLabel: UILabel = {
        let alarmLabel = UILabel()
        alarmLabel.text = "학습 알림"
        alarmLabel.font = .s1
        alarmLabel.textColor = .smeemBlack
        return alarmLabel
    }()
    
    private let alarmContainer: UIView = {
        let alarmContainer = UIView()
        alarmContainer.backgroundColor = .clear
        alarmContainer.layer.borderWidth = 1.5
        alarmContainer.layer.borderColor = UIColor.gray100.cgColor
        alarmContainer.makeRoundCorner(cornerRadius: 6)
        return alarmContainer
    }()
    
    private let alarmPushLabel: UILabel = {
        let pushLabel = UILabel()
        pushLabel.text = "트레이닝 푸시알림"
        pushLabel.font = .b4
        pushLabel.textColor = .smeemBlack
        return pushLabel
    }()
    
    private lazy var alarmPushToggleButton: UISwitch = {
        let button = UISwitch()
        button.onTintColor = .point
        button.addTarget(self, action: #selector(pushButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var alarmCollectionView: AlarmCollectionView = {
        let collectionView = AlarmCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.isUserInteractionEnabled = false
        return collectionView
    }()
    
    private lazy var alarmEditButton: UIView = {
        let view = UIView()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(alarmEditButtonDidTap)))
        return view
    }()
    
    var keyboardHeight: CGFloat = 0.0
    
    // MARK: - Life Cycle
    
    init(myPageManager: MyPageManager, editPushManager: MyPageEditManager) {
        self.mypageManager = myPageManager
        self.editPushManager = editPushManager
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setLayout()
        swipeRecognizer()
        setupHowLearningViewTapGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        myPageGetAPI()
    }
    
    // MARK: - @objc
    
    @objc func backButtonDidTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func moreButtonDidTap(_ sender: UIButton) {
        let authManagetmentVC = AuthManagementViewController(myPageAuthManager: MyPageAuthManagerImpl(myPageAuthService: MyPageAuthServiceImpl(requestable: RequestImpl())))
        self.navigationController?.pushViewController(authManagetmentVC, animated: true)
    }
    
    @objc func editButtonDidTap(_ sender: UIButton) {
        let editVC = EditNicknameViewController(editNicknameManager: MyPageEditManagerImpl(myPageEditService: MyPageEditServiceImpl(requestable: RequestImpl())), nicknameValidManager: NicknameValidManagerImpl(nicknameValidService: NicknameValidServiceImpl(requestable: RequestImpl())))
        editVC.editNicknameDelegate = self
        editVC.nickName = userInfo.username
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    @objc func pushButtonDidTap(_ sender: UIButton) {
        hasAlarm = !hasAlarm
        editPushPatchAPI(hasAlarm: hasAlarm)
    }
    
    @objc func badgeImageDidTap() {
        let badgeListVC = BadgeListViewController(myPageManager: MyPageManagerImpl(myPageService: MyPageServiceImpl(requestable: RequestImpl())))
        self.navigationController?.pushViewController(badgeListVC, animated: true)
    }
    
    @objc func responseToSwipeGesture() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func howLearningViewTapped() {
        let goalVC = GoalViewController(viewtype: .myPage)
        
        if let selectedIndex = getIndexFromGoalText(goalText: userInfo.target) {
            goalVC.selectedGoalIndex = selectedIndex
            goalVC.selectedGoalLabel = goalTextToIndex[userInfo.target]!.1
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(goalDataReceived),
                                               name: NSNotification.Name("goalData"),
                                               object: nil)
        
        self.navigationController?.pushViewController(goalVC, animated: true)
    }
    
    @objc func alarmEditButtonDidTap() {
        let alarmEditVC = EditAlarmViewController(editAlarmManager: MyPageEditManagerImpl(myPageEditService: MyPageEditServiceImpl(requestable: RequestImpl())))
        alarmEditVC.editAlarmDelegate = self
        alarmEditVC.dayIndexPathArray = indexPathArray
        alarmEditVC.trainigDayData = userInfo.trainingTime.day
        alarmEditVC.trainingTimeData = (userInfo.trainingTime.hour, userInfo.trainingTime.minute)
        alarmEditVC.trainigDayData = userInfo.trainingTime.day
        self.navigationController?.pushViewController(alarmEditVC, animated: true)
    }
    
    @objc func goalDataReceived() {
        toastMessageFlag = true
    }
    
    // MARK: - Custom Method
    
    private func setData() {
        let planNameList = userInfo.way.components(separatedBy: " 이상 ")
        let planWayOne = planNameList[0] + " 이상"
        let planWayTwo = planNameList[1]
        let detailPlan = userInfo.detail.split(separator: "\n").map{String($0)}
        
        howLearningView.setData(planName: userInfo.target, planWayOne: planWayOne, planWayTwo: planWayTwo, detailPlanOne: detailPlan[0], detailPlanTwo: detailPlan[1])
        nickNameLabel.text = userInfo.username
        let url = URL(string: userInfo.badge.imageURL)
        badgeImage.kf.setImage(with: url)
        badgeNameLabel.text = (userInfo.badge.name)
        badgeSummaryLabel.text = "축하해요! \(userInfo.badge.name)를 획득했어요!"
        
        // 알람 값 저장
        self.hasAlarm = userInfo.hasPushAlarm
        
        alarmCollectionView.hasAlarm = userInfo.hasPushAlarm
        
        if !userInfo.hasPushAlarm {
            alarmPushToggleButton.isOn = false
            alarmPushToggleButton.tintColor = .lightGray
        } else {
            alarmPushToggleButton.isOn = true
            alarmPushToggleButton.onTintColor = .point
        }
        // 마이페이지 알람 cell 바꾸는 로직
        let dayArray = userInfo.trainingTime.day.split(separator: ",")
        
        // 요일 배열 한번 비워 주는 과정 필요
        indexPathArray.removeAll()
        for i in 0..<dayArray.count {
            indexPathArray.append(myPageSelectedIndexPath[String(dayArray[i])]!)
        }
        
        print("lkfjsadkfdsakfhsadkjf✅✅✅✅✅✅✅✅✅✅, ", self.indexPathArray)
        
        alarmCollectionView.selectedIndexPath = indexPathArray
        alarmCollectionView.myPageTime = (userInfo.trainingTime.hour, userInfo.trainingTime.minute)
    }
    
    private func swipeRecognizer() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(responseToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    private func setupHowLearningViewTapGestureRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(howLearningViewTapped))
        howLearningView.addGestureRecognizer(tapRecognizer)
    }
    
    private func getIndexFromGoalText(goalText: String) -> Int? {
        return goalTextToIndex[goalText]?.0
    }
    
    private func loadToastMessage() {
        showToast(toastType: .defaultToast(bodyType: .changed))
    }
    
    // MARK: - Layout
    
    private func setBackgroundColor() {
        view.backgroundColor = .white
    }
    
    private func setLayout() {
        setBackgroundColor()
        hiddenNavigationBar()
        
        view.addSubviews(headerContainerView, scrollView)
        headerContainerView.addSubviews(backButton, titleLabel, moreButton)
        scrollView.addSubview(contentView)
        contentView.addSubviews(nickNameLabel, editButton, howLearningView, badgeLabel, badgeContainer, languageLabel, languageContainer, alarmLabel, alarmContainer, alarmCollectionView, alarmEditButton)
        badgeContainer.addSubviews(badgeImage, badgeNameLabel, badgeSummaryLabel, badgeMoreButton)
        languageContainer.addSubviews(languageLabelEnglish, languageCheckButton)
        alarmContainer.addSubviews(alarmPushLabel, alarmPushToggleButton)
    
        headerContainerView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(convertByHeightRatio(66))
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.width.height.equalTo(45)
        }
        
        titleLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-10)
            $0.width.height.equalTo(45)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(headerContainerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(convertByHeightRatio(30))
            $0.leading.equalToSuperview().offset(convertByWidthRatio(38))
        }
        
        editButton.snp.makeConstraints {
            $0.centerY.equalTo(nickNameLabel.snp.centerY)
            $0.leading.equalTo(nickNameLabel.snp.trailing)
            $0.width.height.equalTo(convertByWidthRatio(25))
        }
        
        howLearningView.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(convertByHeightRatio(16))
            $0.leading.equalToSuperview().inset(convertByWidthRatio(24))
            $0.centerX.equalToSuperview()
        }
        
        badgeLabel.snp.makeConstraints {
            $0.top.equalTo(howLearningView.snp.bottom).offset(convertByHeightRatio(52))
            $0.leading.equalToSuperview().inset(convertByWidthRatio(24))
        }
        
        badgeContainer.snp.makeConstraints {
            $0.top.equalTo(badgeLabel.snp.bottom).offset(convertByHeightRatio(14))
            $0.leading.trailing.equalTo(howLearningView)
            $0.height.equalTo(convertByHeightRatio(244))
        }
        
        badgeMoreButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(6)
            $0.trailing.equalToSuperview().inset(4)
            $0.height.width.equalTo(40)
        }
        
        badgeImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(convertByHeightRatio(40))
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(convertByWidthRatio(100))
        }
        
        badgeNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(convertByHeightRatio(162))
            $0.centerX.equalToSuperview()
        }
        
        badgeSummaryLabel.snp.makeConstraints {
            $0.top.equalTo(badgeNameLabel.snp.bottom).offset(convertByHeightRatio(8))
            $0.centerX.equalToSuperview()
        }
        
        languageLabel.snp.makeConstraints {
            $0.top.equalTo(badgeContainer.snp.bottom).offset(convertByHeightRatio(52))
            $0.leading.equalToSuperview().inset(convertByWidthRatio(24))
        }
        
        languageContainer.snp.makeConstraints {
            $0.top.equalTo(languageLabel.snp.bottom).offset(convertByHeightRatio(14))
            $0.leading.trailing.equalTo(howLearningView)
            $0.height.equalTo(convertByHeightRatio(54))
        }
        
        languageLabelEnglish.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(convertByWidthRatio(20))
        }
        
        languageCheckButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-convertByWidthRatio(13))
            $0.width.height.equalTo(convertByWidthRatio(40))
        }
        
        alarmLabel.snp.makeConstraints {
            $0.top.equalTo(languageContainer.snp.bottom).offset(convertByHeightRatio(52))
            $0.leading.equalToSuperview().inset(convertByWidthRatio(24))
        }
        
        alarmContainer.snp.makeConstraints {
            $0.top.equalTo(alarmLabel.snp.bottom).offset(convertByHeightRatio(14))
            $0.leading.trailing.equalTo(howLearningView)
            $0.height.equalTo(convertByHeightRatio(54))
        }
        
        alarmPushLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(convertByWidthRatio(20))
        }
        
        alarmPushToggleButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(alarmContainer.snp.trailing).offset(-28)
            $0.width.equalTo(convertByWidthRatio(36))
        }
        
        alarmCollectionView.snp.makeConstraints {
            $0.top.equalTo(alarmContainer.snp.bottom).offset(convertByHeightRatio(10))
            $0.leading.trailing.equalToSuperview().inset(23)
            $0.bottom.equalToSuperview().offset(-convertByHeightRatio(80))
            $0.height.equalTo(convertByHeightRatio(133))
        }
        
        alarmEditButton.snp.makeConstraints {
            $0.edges.equalTo(alarmCollectionView)
            $0.width.height.equalTo(alarmCollectionView)
        }
    }
}

// MARK: - EditNicknameDelegate

extension MyPageViewController: EditMypageDelegate {
    func editMyPageData() {
        toastMessageFlag = true
    }
}

// MARK: - Extension : Network

extension MyPageViewController: ViewControllerServiceable {
    private func myPageGetAPI() {
        showLoadingView()
        Task {
            do {
                self.userInfo = try await mypageManager.getMypage()
                self.setData()
                hideLoadingView()
            } catch {
                guard let error = error as? NetworkError else { return }
                handlerError(error)
            }
        }
    }
    
    private func editPushPatchAPI(hasAlarm: Bool) {
        showLoadingView()
        
        Task {
            do {
                try await editPushManager.editPush(model: EditPushRequest(hasAlarm: hasAlarm))
                
                self.alarmCollectionView.hasAlarm = hasAlarm
                self.alarmCollectionView.selectedIndexPath = self.indexPathArray
                
                if hasAlarm {
                    self.alarmPushToggleButton.isOn = true
                    self.alarmPushToggleButton.onTintColor = .point
                } else {
                    self.alarmPushToggleButton.isOn = false
                    self.alarmPushToggleButton.tintColor = .lightGray
                }
                
                hideLoadingView()
            } catch {
                guard let error = error as? NetworkError else { return }
                handlerError(error)
            }
        }
    }
}
