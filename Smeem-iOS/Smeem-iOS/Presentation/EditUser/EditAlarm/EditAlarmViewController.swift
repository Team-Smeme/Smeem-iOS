//
//  EditAlarmViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/08/21.
//

import UIKit
import Combine

final class EditAlarmViewController: BaseViewController {
    
    // MARK: - Property
    
    let toastSubject = PassthroughSubject<Void, Never>()
    var cancelBag = Set<AnyCancellable>()
    
    var trainigDayData = ""
    var trainingTimeData: (hour: Int, minute: Int)?
    var completeButtonData: Bool?
    
    private var hasAlarm = false
    
    var dayIndexPathArray = [IndexPath]()
    
    // MARK: - UI Property
    
    private let naviView = UIView()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnBack, for: .normal)
        button.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let naviViewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "트레이닝 알림 변경"
        label.font = .s2
        label.textColor = .black
        return label
    }()
    
    private lazy var alarmCollectionView: AlarmCollectionView = {
        let collectionView = AlarmCollectionView()
        return collectionView
    }()
    
    private lazy var completeButton: SmeemButton = {
        let button = SmeemButton(buttonType: .enabled, text: "완료")
        button.addTarget(self, action: #selector(completeButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setData()
    }
    
    private func setDelegate() {
        alarmCollectionView.alarmDelegate = self
    }
    
    // MARK: - @objc
    
    @objc func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func completeButtonDidTap() {
        editAlarmTimePatchAPI(alarmTime: EditAlarmTime(trainingTime: TrainingTime(day: trainigDayData,
                                                                                  hour: trainingTimeData!.hour,
                                                                                  minute: trainingTimeData!.minute)))
    }
    
    // MARK: - Custom Method
    
    private func setData() {
        let buttonType = dayIndexPathArray.isEmpty ? SmeemButtonType.notEnabled : SmeemButtonType.enabled
        completeButton.changeButtonType(buttonType: buttonType)
        alarmCollectionView.selectedIndexPath = dayIndexPathArray
        alarmCollectionView.myPageTime = (trainingTimeData!.0, trainingTimeData!.1)
        alarmCollectionView.selectedDayArray = Set(trainigDayData.components(separatedBy: ","))
    }
    
    private func setLayout() {
        view.addSubviews(naviView, alarmCollectionView, completeButton)
        naviView.addSubviews(backButton, naviViewTitleLabel)
        
        naviView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(66)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(55)
        }
        
        naviViewTitleLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        alarmCollectionView.snp.makeConstraints {
            $0.top.equalTo(naviView.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(convertByHeightRatio(133))
        }
        
        completeButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(50)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(60)
        }
    }
}

/// TODO: 임의 코드
extension EditAlarmViewController: AlarmCollectionViewDelegate {
    func alarmTiemDataSend(data: AlarmTimeAppData) {
        var hour = 0
        
        if data.dayAndNight == "PM" {
            // 12 PM 그대로, 13 ~ 23시까지
            hour = data.hour == "12" ? 12 : Int(data.hour)!+12
        } else {
            // AM 00:00
            hour = data.hour == "12" ? 24 : Int(data.hour)!
        }
        
        let minute = data.minute == "00" ? 0 : 30
        self.trainingTimeData = (hour, minute)
    }
    
    func alarmDayButtonDataSend(day: Set<String>) {
        var day = day
        day.remove("")
        print("넌 뭐냐!", day)
        let dayList = !day.isEmpty ? Array(day).joined(separator: ",") : ""
        print("아 잠만", dayList)
        self.trainigDayData = dayList
        let buttonType = trainigDayData.isEmpty ? SmeemButtonType.notEnabled : SmeemButtonType.enabled
        completeButton.changeButtonType(buttonType: buttonType)
    }
}

extension EditAlarmViewController {
    private func editAlarmTimePatchAPI(alarmTime: EditAlarmTime) {
        SmeemLoadingView.showLoading()
        
        MyPageAPI.shared.editAlarmTimeAPI(param: alarmTime) { response in
            switch response {
            case .success(_):
                self.toastSubject.send(())
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                self.showToast(toastType: .smeemErrorToast(message: error))
            }
            
            SmeemLoadingView.hideLoading()
        }
    }
}
