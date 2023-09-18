//
//  EditAlarmViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/08/21.
//

import UIKit

final class EditAlarmViewController: UIViewController {
    
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
    private let loadingView = LoadingView()
    
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
    
    private lazy var completeButton: SmeemButton = {
        let button = SmeemButton()
        button.setTitle("완료", for: .normal)
        button.addTarget(self, action: #selector(completeButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        setLayout()
        hiddenNavigationBar()
        swipeRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setData()
    }
    
    // MARK: - @objc
    
    @objc func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func completeButtonDidTap() {
        self.showLodingView(loadingView: loadingView)
        editAlarmTimePatchAPI(alarmTime: EditAlarmTime(trainingTime: TrainingTime(day: trainigDayData!,
                                                                                  hour: trainingTimeData!.hour,
                                                                                  minute: trainingTimeData!.minute)))
    }
    
    @objc func responseToSwipeGesture() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func swipeRecognizer() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(responseToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    // MARK: - Custom Method
    
    private func setData() {
        alarmCollectionView.selectedIndexPath = dayIndexPathArray
        alarmCollectionView.myPageTime = (trainingTimeData!.0, trainingTimeData!.1)
        alarmCollectionView.selectedDayArray = Set(trainigDayData!.components(separatedBy: ","))
    }
    
    private func setBackgroundColor() {
        view.backgroundColor = .white
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
        MyPageAPI.shared.editAlarmTimeAPI(param: alarmTime) { respons in
            self.hideLodingView(loadingView: self.loadingView)
            if respons.success == true {
                self.editAlarmDelegate?.editMyPageData()
                self.navigationController?.popViewController(animated: true)
            } else {
                print("학습 목표 API 호출 실패")
            }
        }
    }
}
