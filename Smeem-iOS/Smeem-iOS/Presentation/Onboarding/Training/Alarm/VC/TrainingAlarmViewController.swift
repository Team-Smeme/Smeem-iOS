//
//  TrainingAlarmViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/16.
//

import AppTrackingTransparency
import UIKit
import Combine

enum AlarmType {
    case alarmOff
    case alarmOn
}

final class TrainingAlarmViewController: BaseViewController, BottomSheetPresentable {
    
    private let viewModel = TrainingAlarmViewModel(provider: OnboardingService())
    
    // MARK: Publisher
    
    private var cancelBag = Set<AnyCancellable>()
    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    private let alarmTimeSubject = PassthroughSubject<AlarmTimeAppData, Never>()
    private let alarmDaySubject = PassthroughSubject<Set<String>, Never>()
    private let alarmButtonTapped = PassthroughSubject<AlarmType, Never>()
    private let nextFlowSubject = PassthroughSubject<Void, Never>()
    private let userServiceSubject = PassthroughSubject<Void, Never>()
    private let homeSubject = PassthroughSubject<Void, Never>()
    private let amplitudeSubject = PassthroughSubject<Void, Never>()
    
    // MARK: UI Properties
    
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
        return button
    }()
    
    private lazy var completeButton: SmeemButton = {
        let button = SmeemButton(buttonType: .enabled, text: "완료")
        return button
    }()
    
    private lazy var alarmCollectionView: AlarmCollectionView = {
        let collectionView = AlarmCollectionView()
        return collectionView
    }()
    
    // MARK: - Life Cycle
    
    init(target: String, planId: Int) {
        super.init(nibName: nil, bundle: nil)
        
        viewModel.target = target
        viewModel.planId = planId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setDelegate()
        bind()
        sendInput()
    }
    
    private func setDelegate() {
        alarmCollectionView.alarmDelegate = self
    }
    
    // MARK: - Method
    
    private func bind() {
        laterButton.tapPublisher
            .sink { [weak self] _ in
                self?.alarmButtonTapped.send(.alarmOff)
            }
            .store(in: &cancelBag)
        
        completeButton.tapPublisher
            .sink { [weak self] _ in
                self?.alarmButtonTapped.send(.alarmOn)
            }
            .store(in: &cancelBag)
        
        let input = TrainingAlarmViewModel.Input(viewDidLoadSubject: viewDidLoadSubject,
                                                 alarmTimeSubject: alarmTimeSubject,
                                                 alarmDaySubject: alarmDaySubject,
                                                 alarmButtonTapped: alarmButtonTapped,
                                                 nextFlowSubject: nextFlowSubject,
                                                 userServiceSubject: userServiceSubject,
                                                 homeSubject: homeSubject,
                                                 amplitudeSubject: amplitudeSubject)
        let output = viewModel.transform(input: input)
        
        output.buttonTypeResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] type in
                self?.completeButton.changeButtonType(buttonType: type)
            }
            .store(in: &cancelBag)
        
        output.alarmResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.requestNotificationPermission()
            }
            .store(in: &cancelBag)
        
        output.bottomSheetResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let signupBottomSheetVC = SignupBottomSheetViewController()
                self?.presentBottomSheet(viewController: signupBottomSheetVC, customHeightMultiplier: 0.31)
                
                signupBottomSheetVC.userServiceSubject
                    .sink { [weak self] _ in
                        self?.userServiceSubject.send(())
                    }
                    .store(in: &signupBottomSheetVC.cancelBag)
                
                signupBottomSheetVC.homeSubject
                    .sink { [weak self] _ in
                        self?.homeSubject.send(())
                    }
                    .store(in: &signupBottomSheetVC.cancelBag)
            }
            .store(in: &cancelBag)
        
        output.nicknameResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let userNicknameVC = UserNicknameViewController()
                self?.navigationController?.pushViewController(userNicknameVC, animated: true)
            }
            .store(in: &cancelBag)
        
        output.homeSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let homeVC = HomeViewController()
                self?.changeRootViewController(homeVC)
            }
            .store(in: &cancelBag)
            
        output.errorResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showToast(toastType: .smeemErrorToast(message: error))
            }
            .store(in: &cancelBag)
        
        output.loadingViewResult
            .receive(on: DispatchQueue.main)
            .sink { isShown in
                isShown ? SmeemLoadingView.showLoading() : SmeemLoadingView.hideLoading()
            }
            .store(in: &cancelBag)
    }
    
    private func sendInput() {
        self.viewDidLoadSubject.send(())
        self.amplitudeSubject.send(())
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
    
    func requestTrackingAuthoriaztion() {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                print("성공")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.nextFlowSubject.send(())
                }
            case .denied:
                print("해당 앱 추적 권한 거부 또는 아이폰 설정 -> 개인정보보호 -> 추적 거부 상태")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.nextFlowSubject.send(())
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
}

// MARK: - Delegate

extension TrainingAlarmViewController: AlarmCollectionViewDelegate {
    func alarmTiemDataSend(data: AlarmTimeAppData) {
        alarmTimeSubject.send(data)
    }
    
    func alarmDayButtonDataSend(day: Set<String>) {
        alarmDaySubject.send(day)
    }
}

// MARK: - Layout

extension TrainingAlarmViewController {
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
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(convertByHeightRatio(133))
        }
        
        completeButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(convertByHeightRatio(18))
            $0.bottom.equalToSuperview().inset(convertByHeightRatio(50))
            $0.height.equalTo(convertByHeightRatio(60))
        }
        
        laterButton.snp.makeConstraints {
            $0.bottom.equalTo(completeButton.snp.top).offset(convertByHeightRatio(-9))
            $0.centerX.equalToSuperview()
            $0.height.equalTo(39)
        }
    }
}
