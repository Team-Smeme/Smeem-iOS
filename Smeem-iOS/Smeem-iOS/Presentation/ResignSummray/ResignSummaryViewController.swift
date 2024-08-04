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
    private let resignButtonTapped = PassthroughSubject<Void, Never>()
    private let keyboardSubject = PassthroughSubject<KeyboardType, Never>()
    private let keyboardHeightSubject = PassthroughSubject<KeyboardInfo, Never>()
    private let summaryTextSubject = PassthroughSubject<String, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    private let viewModel = ResignSummaryViewModel(provider: AuthService())
    
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
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
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
        
        resignButton.tapPublisher
            .handleEvents(receiveOutput: {[weak self] _ in
                self?.summaryTextView.resignFirstResponder()
            })
            .sink { [weak self] _ in
                let alert = UIAlertController(title: "계정을 삭제하시겠습니까?", message: "이전에 작성했던 일기는 모두 사라집니다.", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "취소", style: .cancel) { _ in }
                let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
                    self?.resignButtonTapped.send(())
                }
                alert.addAction(cancel)
                alert.addAction(delete)
                self?.present(alert, animated: true, completion: nil)
            }
            .store(in: &cancelBag)
        
        backButton.tapPublisher
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancelBag)
        
        let output = viewModel.transform(input: ResignSummaryViewModel.Input(viewWillAppearSubject: viewWillAppearSubject,
                                                                            cellTapped: cellTapped,
                                                                            buttonTapped: resignButtonTapped,
                                                                            keyboardSubject: keyboardSubject,
                                                                            keyboardHeightSubject: keyboardHeightSubject,
                                                                            summaryTextSubject: summaryTextSubject))
        output.viewWillAppearResult
            .sink { array in
                self.trainingGoalCollectionView.planGoalArray = array
                self.trainingGoalCollectionView.reloadData()
            }
            .store(in: &cancelBag)
        
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
        
        output.keyboardResult
            .sink { [weak self] keyboardValue in
                UIView.animate(withDuration : 0.3) {
                    self?.view.frame.origin.y = keyboardValue
                }
            }
            .store(in: &cancelBag)
        
        output.resignResult
            .sink { [weak self] _ in
                self?.changeRootViewController(SplashViewController())
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

extension ResignSummaryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "계정 삭제 사유를 적어주세요." {
            textView.text = nil
            textView.textColor = .black
        }
        
        let selectedLastIndexPath = IndexPath(item: 4, section: 0)
        trainingGoalCollectionView.selectItem(at: selectedLastIndexPath, animated: true, scrollPosition: [])
        trainingGoalCollectionView.collectionView(trainingGoalCollectionView,
                                                  didSelectItemAt: selectedLastIndexPath)
        let deSelectedIndexPath = (0...3).map { IndexPath(item: $0, section: 0) }
        deSelectedIndexPath.forEach { indexPath in trainingGoalCollectionView.collectionView(trainingGoalCollectionView,
                                                                                             didDeselectItemAt: indexPath) }
        self.cellTapped.send(4)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "계정 삭제 사유를 적어주세요."
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.summaryTextSubject.send((textView.text))
    }
}
