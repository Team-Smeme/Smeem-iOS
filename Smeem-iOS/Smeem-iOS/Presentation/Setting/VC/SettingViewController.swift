//
//  SettingViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 5/7/24.
//

import UIKit
import Combine

import SnapKit

final class SettingViewController: BaseViewController {
    
    private let viewWillAppearSubject = PassthroughSubject<Void, Never>()
    private let nicknameButtonTapped = PassthroughSubject<Void, Never>()
    private let planButtonTapped = PassthroughSubject<Void, Never>()
    private let alarmToggleTapped = PassthroughSubject<Void, Never>()
    private let alarmButtnTapped = PassthroughSubject<Void, Never>()
    private let errorSubject = PassthroughSubject<SmeemError, Never>()
    private var cancelBag = Set<AnyCancellable>()
    private let toastSubject = PassthroughSubject<Void, Never>()
    private let viewModel = SettingViewModel(provider: SettingService())
    
    private let summaryScrollerView = UIScrollView()
    private let contentView = UIView()
    
    private let naviView = UIView()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnBack, for: .normal)
        return button
    }()
    
    private let summaryLabel: UILabel = {
        let label = UILabel()
        label.text = "설정"
        label.font = .s2
        label.textColor = .black
        return label
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnMore, for: .normal)
        return button
    }()
    
    private let nicknameContainerView = NicknameContainerView()
    private let planContainerView = PlanContainerView()
    private let languageContainerView = LanguageContainerView()
    private let alarmContainerView = AlarmContainerView()
    private let alarmCollectionContainerView = UIView()
    private let alarmCollectionView = AlarmCollectionView()
    private let separationLine = SeparationLine(height: .thin)
    private let sendFeedbackView = SendFeedbackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewWillAppearSubject.send(())
    }
    
    private func bind() {
        backButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancelBag)
        
        moreButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let authVC = AuthManagementViewController()
                self?.navigationController?.pushViewController(authVC, animated: true)
            }
            .store(in: &cancelBag)
        
        nicknameContainerView.editButtonTapped
            .sink { [weak self] _ in
                self?.nicknameButtonTapped.send(())
            }
            .store(in: &cancelBag)
        
        planContainerView.editButtonTapped
            .sink { [weak self] _ in
                self?.planButtonTapped.send(())
            }
            .store(in: &cancelBag)
        
        alarmContainerView.toggleTapped
            .sink { [weak self] _ in
                self?.alarmToggleTapped.send(())
            }
            .store(in: &cancelBag)
        
        alarmCollectionContainerView.gesturePublisher
            .sink { [weak self] _ in
                self?.alarmButtnTapped.send(())
            }
            .store(in: &cancelBag)
        
        sendFeedbackView.directButtonTapped
            .sink { _ in
                guard let url = URL(string: "https://walla.my/survey/2SAyT8aWPKjqaL4cZ5vm") else { return }
                UIApplication.shared.open(url, options: [:]) { success in
                    if success {
                        self.errorSubject.send(.clientError)
                    }
                }
                
            }
            .store(in: &cancelBag)
        
        let output = viewModel.transform(input: SettingViewModel.Input(viewWillAppearSubject: viewWillAppearSubject,
                                                                       alarmToggleSubject: alarmToggleTapped,
                                                                       nicknameButtonTapped: nicknameButtonTapped,
                                                                       planButtonTapped: planButtonTapped,
                                                                       alarmButtonTapped: alarmButtnTapped,
                                                                       errorSubject: errorSubject))
        output.hasPlanResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                self?.nicknameContainerView.setNicknameData(data: response.nickname)
                self?.planContainerView.hasPlanData(data: response.plan!.content)
                self?.alarmContainerView.setAlarmData(data: response.hasPushAlarm)
                self?.alarmCollectionView.selectedIndexPath = response.alarmIndexPath
                self?.alarmCollectionView.hasAlarm = response.hasPushAlarm
                self?.alarmCollectionView.myPageTime = (response.alarmTime.hour, response.alarmTime.minute)
                self?.alarmCollectionView.reloadData()
            }
            .store(in: &cancelBag)
        
        output.hasNotPlanResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                self?.nicknameContainerView.setNicknameData(data: response.nickname)
                self?.planContainerView.hasNotPlanData()
                self?.alarmContainerView.setAlarmData(data: response.hasPushAlarm)
                self?.alarmCollectionView.selectedIndexPath = response.alarmIndexPath
                self?.alarmCollectionView.hasAlarm = response.hasPushAlarm
                self?.alarmCollectionView.myPageTime = (response.alarmTime.hour, response.alarmTime.minute)
                self?.alarmCollectionView.reloadData()
            }
            .store(in: &cancelBag)
        
        output.alarmToggleResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] hasAlarm in
                self?.alarmContainerView.setAlarmData(data: hasAlarm)
                self?.alarmCollectionView.hasAlarm = hasAlarm
            }
            .store(in: &cancelBag)
        
        output.nicknameResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] nickname in
                let editNicknameVC = EditNicknameViewController()
                editNicknameVC.toastSubject
                    .sink { [weak self] _ in
                        self?.toastSubject.send(())
                    }
                    .store(in: &editNicknameVC.cancelBag)
                editNicknameVC.nickName = nickname
                self?.navigationController?.pushViewController(editNicknameVC, animated: true)
            }
            .store(in: &cancelBag)
        
        output.planButtonResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] plan in
                let editPlanVC = EditPlanViewController(planId: plan?.id)
                editPlanVC.toastSubject
                    .sink { [weak self] _ in
                        self?.toastSubject.send(())
                    }
                    .store(in: &editPlanVC.cancelBag)
                self?.navigationController?.pushViewController(editPlanVC, animated: true)
            }
            .store(in: &cancelBag)
        
        output.alarmButtonResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (indexPath, time) in
                let editAlarmVC = EditAlarmViewController()
                editAlarmVC.dayIndexPathArray = indexPath
                editAlarmVC.trainigDayData = time.day
                editAlarmVC.trainingTimeData = (time.hour, time.minute)
                self?.navigationController?.pushViewController(editAlarmVC, animated: true)
                
                editAlarmVC.toastSubject
                    .sink { [weak self] _ in
                        self?.toastSubject.send(())
                    }
                    .store(in: &editAlarmVC.cancelBag)
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
        
        self.toastSubject
            .delay(for: .seconds(0.3), scheduler: DispatchQueue.main) // 3초 지연
            .sink { [weak self] _ in
                self?.showToast(toastType: .smeemToast(bodyType: .changed))
            }
            .store(in: &cancelBag)
    }
    
    private func setLayout() {
        view.addSubviews(naviView, summaryScrollerView)
        naviView.addSubviews(backButton, summaryLabel, moreButton)
        summaryScrollerView.addSubview(contentView)
        contentView.addSubviews(nicknameContainerView,
                                planContainerView,
                                languageContainerView,
                                alarmContainerView,
                                alarmCollectionView,
                                separationLine,
                                sendFeedbackView)
        alarmCollectionView.addSubview(alarmCollectionContainerView)
        
        naviView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(66)
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
            $0.height.width.equalTo(40)
        }
        
        summaryLabel.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.height.width.equalTo(40)
        }
        
        // MARK: - summaryScrollerView
        
        summaryScrollerView.snp.makeConstraints {
            $0.top.equalTo(naviView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.leading.centerX.equalToSuperview()
        }
        
        nicknameContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(87)
        }
        
        planContainerView.snp.makeConstraints {
            $0.top.equalTo(nicknameContainerView.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(87)
        }
        
        languageContainerView.snp.makeConstraints {
            $0.top.equalTo(planContainerView.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(87)
        }
        
        alarmContainerView.snp.makeConstraints {
            $0.top.equalTo(languageContainerView.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(87)
        }
        
        alarmCollectionView.snp.makeConstraints {
            $0.top.equalTo(alarmContainerView.snp.bottom).offset(convertByHeightRatio(10))
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(133)
        }
        
        alarmCollectionContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        separationLine.snp.remakeConstraints {
            $0.top.equalTo(alarmCollectionView.snp.bottom).offset(28)
            $0.height.equalTo(1)
            $0.leading.trailing.equalTo(nicknameContainerView)
        }
        
        separationLine.backgroundColor = .gray100
        
        sendFeedbackView.snp.makeConstraints {
            $0.top.equalTo(separationLine.snp.bottom).offset(28)
            $0.leading.trailing.equalTo(alarmContainerView)
            $0.height.equalTo(88)
            $0.bottom.equalToSuperview()
        }
    }
}
