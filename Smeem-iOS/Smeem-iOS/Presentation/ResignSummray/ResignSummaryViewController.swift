//
//  ResignSummaryViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 7/7/24.
//

import UIKit
import Combine

final class ResignSummaryViewController: BaseViewController, UITextViewDelegate {
    
    // MARK: Publisher
    
    private let viewWillAppearSubject = PassthroughSubject<Void, Never>()
    private let cellTapped = PassthroughSubject<Int, Never>()
    private let nextButtonTapped = PassthroughSubject<Void, Never>()
    private let keyboardSubject = PassthroughSubject<KeyboardType, Never>()
    private let keyboardHeightSubject = PassthroughSubject<KeyboardInfo, Never>()
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
        return label
    }()
    
    private let summaryTextView: UITextView = {
        let textView = UITextView()
        textView.text = "계정 삭제 사유를 적어주세요."
        textView.textColor = .gray400
        textView.font = .b4
        textView.backgroundColor = .gray100
        textView.contentInset = UIEdgeInsets(top: 11, left: 11, bottom: 11, right: 11)
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
        setDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewWillAppearSubject.send(())
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.summaryTextView.resignFirstResponder()
    }
    
    // MARK: - Method
    
    private func bind() {
        NotificationCenter.default.publisher(for: UITextView.textDidBeginEditingNotification, object: summaryTextView)
            .sink { _ in
//                self.keyboardSubject.send(.up)
            }
            .store(in: &cancelBag)
        
        NotificationCenter.default.publisher(for: UITextView.textDidEndEditingNotification, object: summaryTextView)
            .sink { [weak self] _ in
                self?.keyboardHeightSubject.send(KeyboardInfo(type: .down, keyboardHeight: nil, viewHeight: nil))
            }
            .store(in: &cancelBag)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
            .map { $0.cgRectValue.height }
            .sink { [weak self] keyboardHeight in
                self?.keyboardHeightSubject.send(KeyboardInfo(type: .up,
                                                              keyboardHeight: keyboardHeight,
                                                              viewHeight: self!.view.frame.origin.y))
            }
            .store(in: &cancelBag)
        
        let output = viewModel.transform(input: ResignSummaryViewModel.Input(viewWillAppearSubject: viewWillAppearSubject,
                                                                            cellTapped: cellTapped,
                                                                            buttonTapped: nextButtonTapped,
                                                                            keyboardSubject: keyboardSubject,
                                                                            keyboardHeightSubject: keyboardHeightSubject))
        output.viewWillAppearResult
            .sink { array in
                self.trainingGoalCollectionView.planGoalArray = array
                self.trainingGoalCollectionView.reloadData()
            }
            .store(in: &cancelBag)
        
        output.cellResult
            .sink { [weak self] string in
                print(string)
            }
            .store(in: &cancelBag)
        
//        output.buttonResult
//            .sink { [weak self] type in
//                self?.resignButton.changeButtonType(buttonType: type)
//            }
//            .store(in: &cancelBag)
        
        output.enabledButtonResult
            .sink { [weak self] type in
                self?.resignButton.changeButtonType(buttonType: type)
            }
            .store(in: &cancelBag)
        
        output.notEnabledButtonResult
            .sink { [weak self] type in
                self?.resignButton.changeButtonType(buttonType: type)
                self?.summaryTextView.becomeFirstResponder()
            }
            .store(in: &cancelBag)
        
        let viewY = self.view.safeAreaLayoutGuide.snp.height
        print(viewY)
        
        output.keyboardResult
            .sink { [weak self] keyboardValue in
                UIView.animate(withDuration : 0.3) {
                    self?.view.frame.origin.y = keyboardValue
                }
            }
            .store(in: &cancelBag)
    }
    
    private func setDelegate() {
        trainingGoalCollectionView.resignSummaryDelegate = self
        self.summaryTextView.delegate = self
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
