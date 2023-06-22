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
    
    var isAlarmData = Bool()
    var targetData = String()
    var trainingTimeData: TrainingTime?
    
    var trainingClosure: ((TrainingTime) -> Void)?
    
    // MARK: - UI Property
    
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
        label.text = "학습 시간 설정"
        label.font = .h2
        label.textColor = .black
        return label
    }()
    
    private let deatilTimeSettingLabel: UILabel = {
        let label = UILabel()
        label.text = "잊지 않도록 알림을 드릴게요."
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
        button.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var completeButton: SmeemButton = {
        let button = SmeemButton()
        button.smeemButtonType = .enabled
        button.setTitle("완료", for: .normal)
        button.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var alarmCollectionView: AlarmCollectionView = {
        let collectionView = AlarmCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.trainingDayClosure = { trainingData in
            self.trainingTimeData = trainingData
        }
        return collectionView
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        setLayout()
    }
    
    // MARK: - @objc
    
    @objc func nextButtonDidTap(){
//        requestNotificationPermission()
    }
    
    // MARK: - Custom Method
    
    func requestNotificationPermission(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: { didAllow, error in
            if didAllow {
                print("Push: 권한 허용")
                self.isAlarmData = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.requestTrackingAuthoriaztion()
                }
            } else {
                print("Push: 권한 거부")
                self.isAlarmData = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
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
            case .denied:
                print("해당 앱 추적 권한 거부 또는 아이폰 설정 -> 개인정보보호 -> 추적 거부 상태")
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
            $0.leading.equalToSuperview().inset(26)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(36)
        }
        
        divisionLabel.snp.makeConstraints {
            $0.leading.equalTo(nowStepOneLabel.snp.trailing).offset(2)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(40)
        }
        
        totalStepLabel.snp.makeConstraints {
            $0.leading.equalTo(divisionLabel.snp.trailing).offset(1)
            $0.top.equalTo(divisionLabel.snp.top)
        }
        
        timeSettingLabelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(26)
            $0.top.equalTo(totalStepLabel.snp.bottom).offset(19)
        }
        
        alarmCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(23)
            $0.top.equalTo(timeSettingLabelStackView.snp.bottom).offset(28)
            $0.height.equalTo(convertByHeightRatio(133))
        }
        
        completeButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(50)
            $0.height.equalTo(convertByHeightRatio(60))
        }
        
        laterButton.snp.makeConstraints {
            $0.bottom.equalTo(completeButton.snp.top).offset(-19)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(19)
        }
    }

}