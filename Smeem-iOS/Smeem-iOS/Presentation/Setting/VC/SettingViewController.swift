//
//  SettingViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 5/7/24.
//

import UIKit
import Combine

final class SettingViewController: BaseViewController {
    
    private let viewWillAppearSubject = PassthroughSubject<Void, Never>()
    private let nicknameButtonTapped = PassthroughSubject<Void, Never>()
    private let planButtonTapped = PassthroughSubject<Void, Never>()
    private let alarmToggleTapped = PassthroughSubject<Void, Never>()
    private let alarmButtnTapped = PassthroughSubject<Void, Never>()
    private var cancelBag = Set<AnyCancellable>()
    private let toastSubject = PassthroughSubject<Void, Never>()
    private let viewModel = SettingViewModel(provider: SettingService())
    
    private let summaryScrollerView: UIScrollView = {
        let scrollerView = UIScrollView()
        scrollerView.showsVerticalScrollIndicator = false
        return scrollerView
    }()
    
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
    
    private let planContainerView = PlanContainerView()
    private let nicknameContainerView = NicknameContainerView()
    private let languageContainerView = LanguageContainerView()
    private let alarmContainerView = AlarmContainerView()
    private let alarmCollectionContainerView = UIView()
    private let alarmCollectionView = AlarmCollectionView()
    
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
        
        let output = viewModel.transform(input: SettingViewModel.Input(viewWillAppearSubject: viewWillAppearSubject,
                                                                       alarmToggleSubject: alarmToggleTapped,
                                                                       nicknameButtonTapped: nicknameButtonTapped,
                                                                       planButtonTapped: planButtonTapped,
                                                                       alarmButtonTapped: alarmButtnTapped))
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
            .delay(for: .seconds(0.5), scheduler: DispatchQueue.main) // 3초 지연
            .sink { [weak self] _ in
                self?.showToast(toastType: .smeemToast(bodyType: .changed))
            }
            .store(in: &cancelBag)
    }
    
    private func setLayout() {
        view.addSubviews(naviView, summaryScrollerView)
        naviView.addSubviews(backButton, summaryLabel, moreButton)
        summaryScrollerView.addSubview(contentView)
        contentView.addSubviews(planContainerView, nicknameContainerView,
                                languageContainerView, alarmContainerView, alarmCollectionView)
        alarmCollectionView.addSubview(alarmCollectionContainerView)
        
        naviView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(66)
        }
        
        summaryScrollerView.snp.makeConstraints {
            $0.top.equalTo(naviView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(summaryScrollerView.contentLayoutGuide)
            $0.width.equalTo(summaryScrollerView.frameLayoutGuide)
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
        
        nicknameContainerView.snp.makeConstraints {
            $0.top.equalTo(naviView.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(convertByHeightRatio(87))
        }
        
        planContainerView.snp.makeConstraints {
            $0.top.equalTo(nicknameContainerView.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(convertByHeightRatio(87))
        }
        
        languageContainerView.snp.makeConstraints {
            $0.top.equalTo(planContainerView.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(convertByHeightRatio(87))
        }
        
        alarmContainerView.snp.makeConstraints {
            $0.top.equalTo(languageContainerView.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(convertByHeightRatio(87))
        }
        
        alarmCollectionView.snp.makeConstraints {
            $0.top.equalTo(alarmContainerView.snp.bottom).offset(convertByHeightRatio(10))
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(convertByHeightRatio(80))
            $0.height.equalTo(convertByHeightRatio(133))
        }
        
        alarmCollectionContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.height.equalTo(alarmCollectionView)
        }
    }
}
