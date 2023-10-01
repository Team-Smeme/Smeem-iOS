//
//  AlarmSettingViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/16.
//

import AppTrackingTransparency
import UIKit

final class AlarmSettingViewController: UIViewController {
    
    // MARK: - Property
    
    var targetData = String()
    var trainigDayData: String?
    var trainingTimeData: (hour: Int, minute: Int)?
    var userPlanData: UserPlanRequest?
    var completeButtonData: Bool?
    
    private var hasAlarm = false
    
    var trainingClosure: ((TrainingTime) -> Void)?
    
    // MARK: - UI Property
    
    private let loadingView = LoadingView()
    
    private let nowStepOneLabel: UILabel = {
        let label = UILabel()
        label.text = "3"
        label.font = .s1
        label.setTextWithLineHeight(lineHeight: 21)
        label.textColor = .point
        return label
    }()
    
    private let divisionLabel: UILabel = {
        let label = UILabel()
        label.text = "/"
        label.font = .c3
        label.textColor = .black
        return label
    }()
    
    private let totalStepLabel: UILabel = {
        let label = UILabel()
        label.text = "3"
        label.font = .c3
        label.textColor = .black
        return label
    }()
    
    private let titleTimeSettingLabel: UILabel = {
        let label = UILabel()
        label.text = "트레이닝 시간 설정"
        label.font = .h2
        label.textColor = .black
        return label
    }()
    
    private let deatilTimeSettingLabel: UILabel = {
        let label = UILabel()
        label.text = "당신의 목표를 이룰 수 있도록 알림을 드릴게요!"
        label.font = .b4
        label.textColor = .black
        return label
    }()
    
    private let timeSettingLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 6
        return stackView
    }()
    
    private lazy var laterButton: UIButton = {
        let button = UIButton()
        button.setTitle("나중에 설정하기", for: .normal)
        button.setTitleColor(.gray600, for: .normal)
        button.titleLabel?.font = .b4
        button.addTarget(self, action: #selector(laterButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var completeButton: SmeemButton = {
        let button = SmeemButton()
        button.smeemButtonType = .enabled
        button.setTitle("완료", for: .normal)
        button.addTarget(self, action: #selector(completeButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var alarmCollectionView: AlarmCollectionView = {
        let collectionView = AlarmCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        collectionView.trainingDayClosure = { traingData in
            self.trainigDayData = traingData.day
            self.completeButton.smeemButtonType = traingData.type
        }
        collectionView.trainingTimeClosure = { data in
            self.trainingTimeData = data
        }
        return collectionView
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        setLayout()
        swipeRecognizer()
    }
    
    // MARK: - @objc
    
    @objc func completeButtonDidTap(){
        self.hasAlarm = true
        requestNotificationPermission()
    }
    
    @objc func responseToSwipeGesture() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func laterButtonDidTap() {
        self.hasAlarm = false
        requestNotificationPermission()
    }
    
    // 로그인 플로우로 들어온 사람 -> NotiToken(accessToken, loginType)
    // 회원가입 플로우로 들어온 사람 -> NotiToken(_, signupType)
    
    // objc func notification : loginType일 경우, accessToken 깡으로 담아서 요청 서버 통신 완료 후, 닉네임 변경 뷰로 이동
    // objc func notification : signupTupe일 경우, 바텀시트를 먼저 보여 준 후, 바텀 시트에서 acessToken을 받아오고, 깡으로 요청 서버서 보냄. 그리고 다시 해당 acessToken을 noti로 쏴줌 다음에 닉네임 변경 뷰로 이동
    // 이용약관 동의에서 어떤 노티든 구독해서 acess 받아줌.
    
    // 로그인 플로우로 들어온 사람 -> 임시 토큰으로 (accessToken, loginType 값 들고 있기)
    // 이탈했을 경우 : 다시 로그인하기 때문에, 임시 토큰도 다시 넣음 ( 고정적이지 않음 )
    // 회원가입 플로우로 들어온 사람 임시 토큰으로 AccessToken, signin 값 들고 있기 1. 대환 토큰
    // 이탈했을 경우, 다시 회원가입 바텀시트로 시작해도 다시 임시 토큰 넣음 2. 수민 토큰
    // 이탈했다가 로그인할 경우, hasPlan은 true이기 때문에, 닉네임 수정뷰로 이동시키고 가장 마지막 토큰을 가지고 api 요청
    
    // MARK: - Custom Method
    
    private func swipeRecognizer() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(responseToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
   private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { didAllow, error in
            if didAllow {
                print("Push: 권한 허용")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.requestTrackingAuthoriaztion()
                }
            } else {
                print("Push: 권한 거부")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.requestTrackingAuthoriaztion()
                }
            }
        })
    }
    
    private func presentBottomSheet(target: String, hasAlarm: Bool) {
        let signupBottomSheetVC = LoginBottomSheetViewController(loginManager: LoginManagerImpl(loginService: LoginServiceImpl(requestable: RequestImpl())))
        let navigationController = UINavigationController(rootViewController: signupBottomSheetVC)
        navigationController.modalPresentationStyle = .overFullScreen
        navigationController.isNavigationBarHidden = true
        
        var userPlanRequest = UserPlanRequest(target: String(),
                                              trainingTime: TrainingTime(day: String(), hour: Int(), minute: Int()),
                                              hasAlarm: Bool())
        
        
        if trainingTimeData == nil && trainigDayData == nil {
            userPlanRequest = UserPlanRequest(target: target,
                                                            trainingTime: TrainingTime(day: "MON,TUE,WED,THU,FRI",
                                                                                       hour: 22,
                                                                                       minute: 0),
                                                            hasAlarm: hasAlarm)
        } else if trainingTimeData == nil && trainigDayData != nil {
            userPlanRequest = UserPlanRequest(target: target,
                                                            trainingTime: TrainingTime(day: trainigDayData ?? "",
                                                                                       hour: 22,
                                                                                       minute: 0),
         
                                                            hasAlarm: hasAlarm)
        } else if trainingTimeData != nil && trainigDayData == nil {
            userPlanRequest = UserPlanRequest(target: target,
                                                            trainingTime: TrainingTime(day: "MON,TUE,WED,THU,FRI",
                                                                                       hour: trainingTimeData?.hour ?? 0,
                                                                                       minute: trainingTimeData?.minute ?? 0),
                                                            hasAlarm: hasAlarm)
        } else {
            userPlanRequest = UserPlanRequest(target: target,
                                                            trainingTime: TrainingTime(day: trainigDayData ?? "",
                                                                                       hour: trainingTimeData?.hour ?? 0,
                                                                                       minute: trainingTimeData?.minute ?? 0),
                                                            hasAlarm: hasAlarm)
        }
        
        /// 로그인하지 않은 유저일 경우, 회원가입 바텀시트 띄우기
        /// 앞에서 로그인하고 온 유저라는 것을 어떻게 아는가?
        if UserDefaultsManager.clientAuthType == AuthType.signup.rawValue {
            signupBottomSheetVC.authType = .signup
            signupBottomSheetVC.bottomSheetView.viewType = .signUp
            signupBottomSheetVC.userPlanRequest = userPlanRequest
            signupBottomSheetVC.modalPresentationStyle = .overFullScreen
            self.present(navigationController, animated: false) {
                signupBottomSheetVC.bottomSheetView.frame.origin.y = self.view.frame.height
                UIView.animate(withDuration: 0.3) {
                    signupBottomSheetVC.bottomSheetView.frame.origin.y = self.view.frame.height-signupBottomSheetVC.defaultLoginHeight
                }
            }
        } else {
        /// 로그인한 유저라면 닉네임 설정 뷰로 이동
            self.showLodingView(loadingView: loadingView)
            self.userPlanPatchAPI(userPlan: userPlanRequest, accessToken: UserDefaultsManager.clientAccessToken)
        }
    }
    
    func requestTrackingAuthoriaztion() {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                print("성공")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.presentBottomSheet(target: self.targetData, hasAlarm: self.hasAlarm)
                }
            case .denied:
                print("해당 앱 추적 권한 거부 또는 아이폰 설정 -> 개인정보보호 -> 추적 거부 상태")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.presentBottomSheet(target: self.targetData, hasAlarm: self.hasAlarm)
                }
            case .notDetermined:
                print("승인 요청을 받기 전 상태값")
            case .restricted:
                print("앱 추적 데이터 사용 권한이 제한된 경우")
            default:
                print("에러 처리")
            }
        }
    }
    
    // MARK: - Layout
    
    private func setBackgroundColor() {
        view.backgroundColor = .smeemWhite
    }
    
    private func setLayout() {
        view.addSubviews(nowStepOneLabel, divisionLabel, totalStepLabel, timeSettingLabelStackView,
                         alarmCollectionView, laterButton, completeButton)
        timeSettingLabelStackView.addArrangedSubviews(titleTimeSettingLabel, deatilTimeSettingLabel)
        
        nowStepOneLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(convertByHeightRatio(26))
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(convertByHeightRatio(36))
        }
        
        divisionLabel.snp.makeConstraints {
            $0.leading.equalTo(nowStepOneLabel.snp.trailing).offset(convertByHeightRatio(2))
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(convertByHeightRatio(40))
        }
        
        totalStepLabel.snp.makeConstraints {
            $0.leading.equalTo(divisionLabel.snp.trailing).offset(convertByHeightRatio(1))
            $0.top.equalTo(divisionLabel.snp.top)
        }
        
        timeSettingLabelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(convertByHeightRatio(26))
            $0.top.equalTo(totalStepLabel.snp.bottom).offset(convertByHeightRatio(19))
        }
        
        alarmCollectionView.snp.makeConstraints {
            $0.top.equalTo(timeSettingLabelStackView.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(23)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(convertByHeightRatio(133))
        }
        
        completeButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(convertByHeightRatio(18))
            $0.bottom.equalToSuperview().inset(convertByHeightRatio(50))
            $0.height.equalTo(convertByHeightRatio(60))
        }
        
        laterButton.snp.makeConstraints {
            $0.bottom.equalTo(completeButton.snp.top).offset(convertByHeightRatio(-19))
            $0.centerX.equalToSuperview()
            $0.height.equalTo(convertByHeightRatio(19))
        }
    }
}

extension AlarmSettingViewController {
    private func userPlanPatchAPI(userPlan: UserPlanRequest, accessToken: String) {
        OnboardingAPI.shared.userPlanPathAPI(param: userPlan, accessToken: accessToken) { response in
            self.hideLodingView(loadingView: self.loadingView)
            
            if response.success == true {
                let userNicknameVC = UserNicknameViewController()
                self.navigationController?.pushViewController(userNicknameVC, animated: true)
            } else {
                print("학습 목표 API 호출 실패")
            }
        }
    }
}
