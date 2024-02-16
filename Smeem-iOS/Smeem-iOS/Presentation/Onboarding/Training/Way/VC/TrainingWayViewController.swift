//
//  TrainingWayViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/16.
//

import UIKit
import Combine

final class TrainingWayViewController: BaseViewController {
    
    private let viewModel = TrainingWayViewModel()
    
    // MARK: Publisher
    
    private let viewWillAppearSubject = PassthroughSubject<Void, Never>()
    private let nextButtonTapped = PassthroughSubject<Void, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    // MARK: UI Properties
    
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
        label.text = "추천 트레이닝 방법"
        label.font = .h2
        label.textColor = .black
        return label
    }()
    
    private let detailLearningLabel: UILabel = {
        let label = UILabel()
        label.text = "스밈과 함께한다면 분명 목표를 이룰 거예요!"
        label.font = .b4
        label.textColor = .black
        return label
    }()
    
    private let learningLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 6
        return stackView
    }()
    
    private let howLearningView: TrainingWayView = {
        let view = TrainingWayView(type: .none)
        return view
    }()
    
    private lazy var nextButton: SmeemButton = {
        let button = SmeemButton(buttonType: .enabled, text: "다음")
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
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewWillAppearSubject.send(())
    }
    
    // MARK: - Methods
    
    private func bind() {
        nextButton.tapPublisher
            .sink { _ in
                self.nextButtonTapped.send(())
            }
            .store(in: &cancelBag)
        
        let input = TrainingWayViewModel.Input(viewWillAppearSubject: viewWillAppearSubject,
                                               nextButtonTapped: nextButtonTapped)
        let output = viewModel.transform(input: input)
        
        output.viewWillAppearResult
            .receive(on: DispatchQueue.main)
            .sink { appData in
                self.howLearningView.setModel(model: appData)
            }
            .store(in: &cancelBag)
        
        output.nextButtonResult
            .receive(on: DispatchQueue.main)
            .sink { target in
                let alarmVC = TrainingAlarmViewController(target: target)
                self.navigationController?.pushViewController(alarmVC, animated: true)
            }
            .store(in: &cancelBag)
        
        output.errorResult
            .receive(on: DispatchQueue.main)
            .sink { error in
                self.showToast(toastType: .smeemErrorToast(message: error))
            }
            .store(in: &cancelBag)
        
        output.loadingViewResult
            .receive(on: DispatchQueue.main)
            .sink { isShown in
                isShown ? SmeemLoadingView.showLoading() : SmeemLoadingView.hideLoading()
            }
            .store(in: &cancelBag)
    }
}

// MARK: - Layout

extension TrainingWayViewController {
    private func setLayout() {
        view.addSubviews(nowStepOneLabel, divisionLabel, totalStepLabel, learningLabelStackView, howLearningView, nextButton)
        learningLabelStackView.addArrangedSubviews(titleLearningLabel, detailLearningLabel)
        
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
        
        learningLabelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(26)
            $0.top.equalTo(totalStepLabel.snp.bottom).offset(19)
        }
        
        howLearningView.snp.makeConstraints {
            $0.top.equalTo(learningLabelStackView.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(50)
            $0.height.equalTo(convertByHeightRatio(60))
        }
    }
}
