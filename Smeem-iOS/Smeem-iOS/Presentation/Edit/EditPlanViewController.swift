//
//  EditPlanViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 5/9/24.
//

import UIKit
import Combine

final class EditPlanViewController: BaseViewController {
    
    // MARK: Publisher
    
    let toastSubject = PassthroughSubject<Void, Never>()
    var cancelBag = Set<AnyCancellable>()
    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    private let cellTapped = PassthroughSubject<(Int, SmeemButtonType), Never>()
    private let completeButtonTapped = PassthroughSubject<Void, Never>()
    private var editPlanCollectionViewDataSource: TrainingCollectionViewDatasource!
    private let viewModel = EditPlanViewModel()
    
    // MARK: UI Properties
    
    private let navigationBarView = UIView()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnBack, for: .normal)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "트레이닝 플랜 변경"
        label.font = .s2
        label.textColor = .smeemBlack
        return label
    }()
    
    private let editPlanCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private let completeButton: SmeemButton = {
        let button = SmeemButton(buttonType: .notEnabled, text: "완료")
        return button
    }()
    
    // MARK: Life Cycle
    
    init(planId: Int? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        viewModel.planId = planId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        registerCell()
        bind()
        sendInput()
        setDelegate()
    }
    
    // MARK: - Method
    
    private func sendInput() {
        viewDidLoadSubject.send(())
    }
    
    private func bind() {
        backButton.tapPublisher
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancelBag)
        
        completeButton.tapPublisher
            .sink { [weak self] _ in
                self?.completeButtonTapped.send(())
            }
            .store(in: &cancelBag)
        
        self.viewDidLoadSubject.send(())
        
        let input = EditPlanViewModel.Input(viewDidLoadSubject: viewDidLoadSubject,
                                            cellTapped: cellTapped,
                                            completeButtonTapped: completeButtonTapped)
        let output = viewModel.transform(input: input)
        
        output.hasPlanResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (response, planId, type) in
                self?.editPlanCollectionViewDataSource = TrainingCollectionViewDatasource(trainingItems: response,
                                                                                          selectedPlan: planId)
                self?.completeButton.changeButtonType(buttonType: type)
                self?.editPlanCollectionView.dataSource = self?.editPlanCollectionViewDataSource
                self?.editPlanCollectionView.reloadData()
            }
            .store(in: &cancelBag)
        
        output.cellResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] type in
                self?.completeButton.changeButtonType(buttonType: type)
            }
            .store(in: &cancelBag)
        
        output.completeResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.toastSubject.send(())
                self?.navigationController?.popViewController(animated: true)
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
    
    private func registerCell() {
        editPlanCollectionView.registerCell(cellType: TrainingCollectionViewCell.self)
    }
    
    private func setDelegate() {
        editPlanCollectionView.delegate = self
    }
}

// MARK: - UICollectionViewDelegate

extension EditPlanViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrainingCollectionViewCell else { return }
        cell.selctedCell()
        self.cellTapped.send((indexPath.item, .enabled))
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrainingCollectionViewCell else { return }
        cell.desecltedCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellInset: CGFloat = 18
        return CGSize(width: UIScreen.main.bounds.width-(cellInset*2), height: convertByHeightRatio(60))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
}

// MARK: - Layout

extension EditPlanViewController {
    private func setLayout() {
        view.addSubviews(navigationBarView, editPlanCollectionView, completeButton)
        navigationBarView.addSubviews(backButton, titleLabel)
        
        navigationBarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(convertByHeightRatio(66))
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(55)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        editPlanCollectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(completeButton.snp.bottom).offset(80)
        }
        
        completeButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(50)
            $0.height.equalTo(convertByHeightRatio(60))
        }
    }
}

