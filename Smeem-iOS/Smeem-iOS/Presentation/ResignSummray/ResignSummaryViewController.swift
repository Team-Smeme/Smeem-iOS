//
//  ResignSummaryViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 7/7/24.
//

import UIKit
import Combine

final class ResignSummaryViewController: BaseViewController {
    
    // MARK: Publisher
    
    private let viewWillAppearSubject = PassthroughSubject<Void, Never>()
    private let cellTapped = PassthroughSubject<Int, Never>()
    private let nextButtonTapped = PassthroughSubject<Void, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    private let viewModel = ResignSummaryViewModel()
    
    // MARK: UI Properties
    
    private let navigationBarView = UIView()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnBack, for: .normal)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "탈퇴하기"
        label.font = .s2
        label.textColor = .smeemBlack
        return label
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.text = "정말 떠나시는 건가요?"
        label.font = .h2
        label.textColor = .smeemBlack
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.text = """
                     계정을 삭제하는 이유를 선택해주세요.
                     서비스 개선에 참고할게요.
                     """
        label.font = .b3
        label.textColor = .smeemBlack
        label.numberOfLines = 0
        return label
    }()
    
    private let resignStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 6
        return stackView
    }()
    
    private lazy var trainingGoalCollectionView = TrainingGoalsCollectionView(planGoalType: .resign)
    
    private let summaryLabel: UILabel = {
        let label = UILabel()
        label.text = "계정 삭제 사유를 자유롭게 적어주세요."
        label.font = .b2
        label.textColor = .smeemBlack
//        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    private let summaryTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .gray100
        return textView
    }()
    
    private let resignButton: SmeemButton = {
        let button = SmeemButton(buttonType: .notEnabled, text: "탈퇴하기")
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewWillAppearSubject.send(())
    }
    
    // MARK: - Method
    
    private func bind() {
        let output = viewModel.transform(input: ResignSummaryViewModel.Input(viewWillAppearSubject: viewWillAppearSubject,
                                                                            cellTapped: cellTapped,
                                                                            buttonTapped: nextButtonTapped))
        output.viewWillAppearResult
            .sink { array in
                self.trainingGoalCollectionView.planGoalArray = array
                self.trainingGoalCollectionView.reloadData()
            }
            .store(in: &cancelBag)
    }
    
    private func setLayout() {
        view.addSubviews(navigationBarView, resignStackView, trainingGoalCollectionView,
                         summaryLabel, summaryTextView, resignButton)
        navigationBarView.addSubviews(backButton, titleLabel)
        resignStackView.addArrangedSubviews(totalLabel, detailLabel)
        
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
        
        resignStackView.snp.makeConstraints {
            $0.top.equalTo(navigationBarView.snp.bottom).offset(14)
            $0.leading.equalToSuperview().inset(26)
        }
        
        trainingGoalCollectionView.snp.makeConstraints {
            $0.top.equalTo(resignStackView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
        }
        
        summaryLabel.snp.makeConstraints {
            $0.top.equalTo(trainingGoalCollectionView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(26)
        }
        
        summaryTextView.snp.makeConstraints {
            $0.top.equalTo(summaryLabel.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(84)
        }
        
        resignButton.snp.makeConstraints {
            $0.top.equalTo(summaryTextView.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            $0.height.equalTo(convertByHeightRatio(60))
        }
    }
}

extension ResignSummaryViewController: ResignSummaryDataSendDelegate {
    func sendTargetData(summaryInt: Int) {
        self.cellTapped.send(summaryInt)
    }
}
