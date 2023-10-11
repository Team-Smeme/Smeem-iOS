//
//  TrainingAlarmViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/10/10.
//

import AppTrackingTransparency
import UIKit

final class TrainingAlarmViewController: BaseViewController {
    
    // MARK: Properties
    
    var targetString = ""
    
    private var trainingDayString = ""
    private var trainingHour = 22
    private var trainingMinute = 0
    private var hasAlarm = false
    
    // MARK: Network Manager
    
    private let trainingManager: TrainingManager
    
    // MARK: UI Properties
    
    private let trainingAlarmStepView = TrainingStepView(configuration: TrainingStepFactory().createTrainingAlarmStepView())
    private let trainingAlarmCollectionView = AlarmCollectionView()
    private lazy var laterButton = SmeemTextButton(title: "나중에 설정하기", textColor: .gray600, font: .b4)
    private lazy var completeButton = SmeemButton(buttonType: .enabled, text: "완료")
    
    // MARK: Life Cycle
    
    init(trainingManager: TrainingManager) {
        self.trainingManager = trainingManager
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setCollectionViewData()
    }
    
    override func setButtonAction() {
        completeButton.addAction {
            self.requestNotificationPermission()
        }
    }
    
    private func requestNotificationPermission() {
         UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { didAllow, error in
             if didAllow {
                 print("Push: 권한 허용")
                 self.hasAlarm = true
                 self.requestTrackingAuthoriaztion()
             } else {
                 print("Push: 권한 거부")
                 self.hasAlarm = false
                 self.requestTrackingAuthoriaztion()
             }
         })
     }
    
    func requestTrackingAuthoriaztion() {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                print("성공")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.presentBottomSheet()
                }
            case .denied:
                print("해당 앱 추적 권한 거부 또는 아이폰 설정 -> 개인정보보호 -> 추적 거부 상태")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.presentBottomSheet()
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
    
    private func presentBottomSheet() {
        let signupBottomSheetVC = AuthBottomSheetViewController(loginManager: LoginManager(loginService: LoginService(requestable: RequestImpl())))
        signupBottomSheetVC.authProtocol = self
        let navigationVC = UINavigationController(rootViewController: signupBottomSheetVC)
        navigationVC.modalPresentationStyle = .overFullScreen
        
        /// 로그인하지 않은 유저일 경우, 회원가입 바텀시트 띄우기
        /// 앞에서 로그인하고 온 유저라는 것을 어떻게 아는가?
        /// TODO: 공부
        if UserDefaultsManager.clientAccessToken == "" {
            signupBottomSheetVC.bottomSheetView.viewType = .signUp
            signupBottomSheetVC.authType = .signup
            
            self.present(navigationVC, animated: false) {
                signupBottomSheetVC.bottomSheetView.frame.origin.y = self.view.frame.height
                UIView.animate(withDuration: 0.3) {
                    signupBottomSheetVC.bottomSheetView.frame.origin.y = self.view.frame.height-signupBottomSheetVC.defaultHeight
                }
            }
        } else {
            userTrainingInfoPatchAPI()
        }
    }
}

// MARK: - Network

extension TrainingAlarmViewController: ViewControllerServiceable {
    private func userTrainingInfoPatchAPI() {
        showLoadingView()
        Task {
            do {
                try await trainingManager.pathUserTraingInfo(model: UserTrainingInfoRequest(target: self.targetString,
                                                                                            trainingTime: TrainingTime(day: trainingDayString,
                                                                                                                       hour: trainingHour,
                                                                                                                       minute: trainingMinute),
                                                                                            hasAlarm: hasAlarm))
                hideLoadingView()
                
                let userNicknameVC = UserNicknameViewController()
                self.navigationController?.pushViewController(userNicknameVC, animated: true)
            } catch {
                guard let error = error as? NetworkError else { return }
                handlerError(error)
            }
        }
    }
}

// MARK: - TrainingDelegate

extension TrainingAlarmViewController: TrainingAlarmDataSendProtocol {
    func sendTrainingDay(day: String, buttonState: SmeemButtonType) {
        self.trainingDayString = day
        self.completeButton.changeButtonType(buttonType: buttonState)
    }
    
    func sendTrainingTime(hour: Int, minute: Int) {
        self.trainingHour = hour
        self.trainingMinute = minute
    }
}

// MARK: - AuthDataSendProtocol

extension TrainingAlarmViewController: AuthDataSendProtocol {
    func sendTrainingAlarm() {
        userTrainingInfoPatchAPI()
    }
}

// MARK: - CollectionView Closure

// 추후 delegate로 수정 예정
extension TrainingAlarmViewController {
    func setCollectionViewData() {
        trainingAlarmCollectionView.trainingDayClosure = { data in
            self.trainingDayString = data.day
            self.completeButton.changeButtonType(buttonType: data.type)
        }
        
        trainingAlarmCollectionView.trainingTimeClosure = { data in
            self.trainingHour = data.hour
            self.trainingMinute = data.minute
        }
    }
}

// MARK: - Layout

extension TrainingAlarmViewController {
    private func setLayout() {
        view.addSubviews(trainingAlarmStepView, trainingAlarmCollectionView, laterButton, completeButton)
        
        trainingAlarmStepView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(36)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(view.frame.width)
            $0.height.equalTo(convertByHeightRatio(94))
        }
        
        trainingAlarmCollectionView.snp.makeConstraints {
            $0.top.equalTo(trainingAlarmStepView.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(23)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(133)
        }
        
        laterButton.snp.makeConstraints {
            $0.bottom.equalTo(completeButton.snp.top).offset(convertByHeightRatio(-9))
            $0.centerX.equalToSuperview()
            $0.height.equalTo(convertByHeightRatio(39))
        }
        
        completeButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(18)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(convertByHeightRatio(60))
        }
    }
}
