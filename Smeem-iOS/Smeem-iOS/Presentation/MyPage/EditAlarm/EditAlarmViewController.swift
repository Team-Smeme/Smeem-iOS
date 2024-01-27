//
//  EditAlarmViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/08/21.
//

import UIKit

final class EditAlarmViewController: BaseViewController {
    
    // MARK: - Property
    
    weak var editAlarmDelegate: EditMypageDelegate?
    
    var trainigDayData: String?
    var trainingTimeData: (hour: Int, minute: Int)?
    var completeButtonData: Bool?
    
    private var hasAlarm = false
    
    private var trainingClosure: ((TrainingTime) -> Void)?
    
    var dayIndexPathArray = [IndexPath]()
    
    // MARK: - UI Property
    
    private let naviView = UIView()
    private let datePickerFooterView = DatePickerFooterView()
    
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
        
        collectionView.trainingDayClosure = { traingData in
            self.trainigDayData = traingData.day
            self.completeButton.changeButtonType(buttonType: traingData.type)
        }
        collectionView.trainingTimeClosure = { data in
            self.trainingTimeData = data
        }
        return collectionView
    }()
    
    private lazy var completeButton: SmeemButton = {
        let button = SmeemButton(buttonType: .notEnabled, text: "완료")
        button.addTarget(self, action: #selector(completeButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setData()
    }
    
    // MARK: - @objc
    
    @objc func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func completeButtonDidTap() {
        editAlarmTimePatchAPI(alarmTime: EditAlarmTime(trainingTime: TrainingTime(day: trainigDayData!,
                                                                                  hour: trainingTimeData!.hour,
                                                                                  minute: trainingTimeData!.minute)))
    }
    
    // MARK: - Custom Method
    
    private func setData() {
        alarmCollectionView.selectedIndexPath = dayIndexPathArray
        alarmCollectionView.myPageTime = (trainingTimeData!.0, trainingTimeData!.1)
        alarmCollectionView.selectedDayArray = Set(trainigDayData!.components(separatedBy: ","))
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
            $0.leading.trailing.equalToSuperview().inset(23)
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

extension EditAlarmViewController {
    private func editAlarmTimePatchAPI(alarmTime: EditAlarmTime) {
        SmeemLoadingView.showLoading()
        
        MyPageAPI.shared.editAlarmTimeAPI(param: alarmTime) { response in
            switch response {
            case .success(_):
                self.editAlarmDelegate?.editMyPageData()
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                self.showToast(toastType: .smeemErrorToast(message: error))
            }
            
            SmeemLoadingView.hideLoading()
        }
    }
}
