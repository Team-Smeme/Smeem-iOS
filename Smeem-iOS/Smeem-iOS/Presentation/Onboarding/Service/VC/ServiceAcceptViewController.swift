//
//  ServiceAcceptViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/17.
//

import UIKit
import Combine

final class ServiceAcceptViewController: BaseViewController {
    
    private let viewModel = ServiceAcceptViewModel()
    
    // MARK: - Property
    
    private let totalViewTapped = PassthroughSubject<Void, Never>()
    private let cellSelected = PassthroughSubject<Int, Never>()
    private let cellDeselected = PassthroughSubject<Int, Never>()
    private let cellIndexSubject = PassthroughSubject<Int, Never>()
    private let completeButtonTapped = PassthroughSubject<Void, Never>()
    
    private var cancelBag = Set<AnyCancellable>()
    
    // MARK: - UI Property
    
    private let titleServiceLabel: UILabel = {
        let label = UILabel()
        label.text = "서비스 이용약관"
        label.font = .h2
        label.textColor = .smeemBlack
        return label
    }()
    
    private let detailServiceLabel: UILabel = {
        let label = UILabel()
        label.text = "서비스 이용을 위해 약관에 동의해주세요."
        label.font = .b4
        label.textColor = .smeemBlack
        return label
    }()
    
    private lazy var totalAcceptView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.gray100.cgColor
        view.layer.borderWidth = 1.5
        view.makeRoundCorner(cornerRadius: 6)
        return view
    }()
    
    private lazy var checkButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnCheckInactive, for: .normal)
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private let goalLabel: UILabel = {
        let label = UILabel()
        label.font = .b3
        label.text = "전체 동의하기"
        label.textColor = .gray600
        return label
    }()
    
    private lazy var serviceCollectionView = ServiceAcceptCollectionView()
    
    private lazy var completeButton: SmeemButton = {
        let button = SmeemButton(buttonType: .notEnabled, text: "완료")
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setDelegate()
        bind()
    }
    
    init(nickname: String) {
        super.init(nibName: nil, bundle: nil)
        
        viewModel.nickname = nickname
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    private func bind() {
        totalAcceptView.gesturePublisher
            .sink { [weak self] _ in
                self?.totalViewTapped.send(())
            }
            .store(in: &cancelBag)
        
        completeButton.tapPublisher
            .sink { [weak self] _ in
                self?.completeButtonTapped.send(())
            }
            .store(in: &cancelBag)
        
        let input = ServiceAcceptViewModel.Input(totalViewTapped: totalViewTapped,
                                                 cellSelected: cellSelected,
                                                 cellDeselected: cellDeselected,
                                                 cellIndexSubject: cellIndexSubject,
                                                 completeButtonTapped: completeButtonTapped)
        let output = viewModel.transform(input: input)
        
        output.totalViewResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                self?.updateUI(state: model.totalViewState, indexPath: model.indexPathArray)
            }
            .store(in: &cancelBag)
        
        output.cellResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                self?.updateCell(model: model)
            }
            .store(in: &cancelBag)
        
        output.cellIndexResult
            .receive(on: DispatchQueue.main)
            .sink { url in
                UIApplication.shared.open(url, options: [:])
            }
            .store(in: &cancelBag)
        
        output.totalViewStateResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.totalViewUI(state: state)
            }
            .store(in: &cancelBag)
        
        output.completeButtonResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] badges in
                let homeVC = HomeViewController()
                homeVC.badgePopupData = badges
                self?.changeRootViewController(homeVC)
            }
            .store(in: &cancelBag)
        
        output.loadingViewSubject
            .receive(on: DispatchQueue.main)
            .sink { isShown in
                isShown ? SmeemLoadingView.showLoading() : SmeemLoadingView.hideLoading()
            }
            .store(in: &cancelBag)
        
        output.errorSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showToast(toastType: .smeemErrorToast(message: error))
            }
            .store(in: &cancelBag)
    }
    
    private func setDelegate() {
        serviceCollectionView.serviceAcceptProtocol = self
    }
    
    private func totalViewUI(state: Bool) {
        if state {
            goalLabel.font = .b1
            goalLabel.textColor = .point
            totalAcceptView.layer.borderColor = UIColor.point.cgColor
            totalAcceptView.layer.borderWidth = 1.5
            checkButton.setImage(Constant.Image.icnCheckActive, for: .normal)
        } else {
            goalLabel.font = .b3
            goalLabel.textColor = .gray600
            totalAcceptView.layer.borderColor = UIColor.gray100.cgColor
            totalAcceptView.layer.borderWidth = 1.5
            checkButton.setImage(Constant.Image.icnCheckInactive, for: .normal)
        }
    }
    
    private func updateUI(state: Bool, indexPath: Set<Int>) {
        if state {
            completeButton.changeButtonType(buttonType: .enabled)
            goalLabel.font = .b1
            goalLabel.textColor = .point
            totalAcceptView.layer.borderColor = UIColor.point.cgColor
            totalAcceptView.layer.borderWidth = 1.5
            checkButton.setImage(Constant.Image.icnCheckActive, for: .normal)
            
            indexPath.forEach { index in
                if let cell = self.serviceCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? ServiceAcceptCollectionViewCell {
                    cell.selectedCell()
                }
                
                serviceCollectionView.selectItem(at: IndexPath(item: index, section: 0),
                                                 animated: false, scrollPosition: .init())
            }
        } else {
            completeButton.changeButtonType(buttonType: .notEnabled)
            goalLabel.font = .b3
            goalLabel.textColor = .gray600
            totalAcceptView.layer.borderColor = UIColor.gray100.cgColor
            totalAcceptView.layer.borderWidth = 1.5
            checkButton.setImage(Constant.Image.icnCheckInactive, for: .normal)
            
            [0, 1, 2].forEach { index in
                if let cell = self.serviceCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? ServiceAcceptCollectionViewCell {
                    cell.deselectedCell()
                }
                
                serviceCollectionView.deselectItem(at: IndexPath(item: index, section: 0),
                                                   animated: false)
            }
        }
    }
    
    private func updateCell(model: cellStateModel) {
        completeButton.changeButtonType(buttonType: model.buttonType)
        
        if model.cellState {
            if let cell = self.serviceCollectionView.cellForItem(at: IndexPath(item: model.indexPath, section: 0)) as? ServiceAcceptCollectionViewCell {
                cell.selectedCell()
            }
        } else {
            if let cell = self.serviceCollectionView.cellForItem(at: IndexPath(item: model.indexPath, section: 0)) as? ServiceAcceptCollectionViewCell {
                cell.deselectedCell()
            }
        }
    }
    

}

// MARK: - Delegate

extension ServiceAcceptViewController: ServiceAcceptProtocol {
    func selectedCellDataSend(indexPath: Int) {
        self.cellSelected.send(indexPath)
    }
    
    func deselectedCellDataSend(indexPath: Int) {
        self.cellDeselected.send(indexPath)
    }
    
    func cellIndexDataSend(indexPath: Int) {
        self.cellIndexSubject.send(indexPath)
    }
}

// MARK: - Layout

extension ServiceAcceptViewController {
    
    private func setLayout() {
        view.addSubviews(titleServiceLabel, detailServiceLabel, totalAcceptView, serviceCollectionView, completeButton)
        totalAcceptView.addSubviews(checkButton, goalLabel)
        
        titleServiceLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(120)
            $0.leading.equalToSuperview().inset(26)
        }
        
        detailServiceLabel.snp.makeConstraints {
            $0.top.equalTo(titleServiceLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().inset(26)
        }
        
        totalAcceptView.snp.makeConstraints {
            $0.top.equalTo(detailServiceLabel.snp.bottom).offset(28)
            $0.trailing.leading.equalToSuperview().inset(18)
            $0.height.equalTo(60)
        }
        
        checkButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        goalLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(checkButton.snp.trailing).offset(12)
        }
        
        serviceCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.top.equalTo(totalAcceptView.snp.bottom).offset(28)
            $0.bottom.equalTo(completeButton.snp.top)
        }
        
        completeButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(50)
            $0.height.equalTo(convertByHeightRatio(60))
        }
    }
}
