//
//  TrainingPlanViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/14.
//

import UIKit
import Combine

final class TrainingPlanViewController: BaseViewController {
    
    private let viewModel = TrainingPlanViewModel()
    
    // MARK: - Subject
    
    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    private let cellTapped = PassthroughSubject<(Int, SmeemButtonType), Never>()
    private let nextButtonTapped = PassthroughSubject<Void, Never>()
    private let amplitudeSubject = PassthroughSubject<Void, Never>()
    private var cancelbag = Set<AnyCancellable>()
    
    private var trainingCollectionViewDatasource: TrainingCollectionViewDatasource!
    
    // MARK: - UI Components
    
    private let nowStepOneLabel: UILabel = {
        let label = UILabel()
        label.text = "2"
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
    
    private let titleLearningLabel: UILabel = {
        let label = UILabel()
        label.text = "트레이닝 플랜 설정"
        label.font = .h2
        label.textColor = .black
        return label
    }()
    
    private let detailLearningLabel: UILabel = {
        let label = UILabel()
        label.text = "목표를 이루기 위한 일기 작성 플랜을 세워요."
        label.font = .b4
        label.textColor = .black
        return label
    }()
    
    private let trainingLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 6
        return stackView
    }()

    private lazy var trainingPlanCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    
    private lazy var nextButton: SmeemButton = {
        let button = SmeemButton(buttonType: .notEnabled, text: "다음")
        return button
    }()
    
    // MARK: - Life Cycle
    
    init(target: String) {
        super.init(nibName: nil, bundle: nil)
        
        viewModel.target = target
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
        registerCell()
        bind()
        setDelegate()
        sendInput()
    }
    
    // MARK: Methods
    
    private func bind() {
        nextButton.tapPublisher
            .sink { [weak self] _ in
                self?.nextButtonTapped.send(())
            }
            .store(in: &cancelbag)
        
        let input = TrainingPlanViewModel.Input(viewDidLoadSubject: viewDidLoadSubject,
                                                cellTapped: cellTapped,
                                                nextButtonTapped: nextButtonTapped,
                                                amplitudeSubject: amplitudeSubject)
        let output = viewModel.transform(input: input)
        
        output.viewDidLoadResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                self?.trainingCollectionViewDatasource = TrainingCollectionViewDatasource(trainingItems: response)
                self?.trainingPlanCollectionView.dataSource = self?.trainingCollectionViewDatasource
                self?.trainingPlanCollectionView.reloadData()
            }
            .store(in: &cancelbag)
        
        output.cellResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] type in
                self?.nextButton.changeButtonType(buttonType: type)
            }
            .store(in: &cancelbag)
        
        output.nextButtonResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (target, id) in
                let trainingAlarmVC = TrainingAlarmViewController(target: target, planId: id)
                self?.navigationController?.pushViewController(trainingAlarmVC, animated: true)
            }
            .store(in: &cancelbag)
        
        output.errorResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showToast(toastType: .smeemErrorToast(message: error))
            }
            .store(in: &cancelbag)
        
        output.loadingViewResult
            .receive(on: DispatchQueue.main)
            .sink { isShown in
                isShown ? SmeemLoadingView.showLoading() : SmeemLoadingView.hideLoading()
            }
            .store(in: &cancelbag)
    }
    
    private func registerCell() {
        trainingPlanCollectionView.registerCell(cellType: TrainingCollectionViewCell.self)
    }
    
    private func setDelegate() {
        trainingPlanCollectionView.delegate = self
    }
    
    private func sendInput() {
        viewDidLoadSubject.send(())
        amplitudeSubject.send(())
    }
}

// MARK: - UICollectionViewFlowLayout

extension TrainingPlanViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrainingCollectionViewCell else { return }
        cell.selctedCell()
        self.cellTapped.send((indexPath.item+1, .enabled))
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

extension TrainingPlanViewController {
    private func setLayout() {
        view.addSubviews(nowStepOneLabel, divisionLabel, totalStepLabel, trainingLabelStackView, trainingPlanCollectionView, nextButton)
        trainingLabelStackView.addArrangedSubviews(titleLearningLabel, detailLearningLabel)
        
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
        
        trainingLabelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(26)
            $0.top.equalTo(totalStepLabel.snp.bottom).offset(19)
        }
        
        trainingPlanCollectionView.snp.makeConstraints {
            $0.top.equalTo(trainingLabelStackView.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.bottom).offset(80)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(50)
            $0.height.equalTo(convertByHeightRatio(60))
        }
    }
}
