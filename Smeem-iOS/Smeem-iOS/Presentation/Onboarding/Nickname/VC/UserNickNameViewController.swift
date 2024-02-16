//
//  UserNickNameViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/17.
//

import UIKit
import Combine

final class UserNicknameViewController: BaseViewController {
    
    private let viewModel = UserNicknameViewModel()
    
    // MARK: Publisher
    
    private let textFieldSubject = PassthroughSubject<String, Never>()
    private let nextButtonTapped = PassthroughSubject<String, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    var userPlanRequest: TrainingPlanRequest?
    
    // MARK: UI Properties
    
    private let titleNicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임 설정"
        label.font = .h2
        label.textColor = .smeemBlack
        return label
    }()
    
    private let detailNicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임은 마이페이지에서 수정할 수 있어요."
        label.font = .b4
        label.textColor = .smeemBlack
        return label
    }()
    
    private lazy var nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.tintColor = .point
        textField.textColor = .point
        textField.font = .h3
        textField.addPaddingView()
        return textField
    }()
    
    private let nicknameLimitLabel: UILabel = {
        let label = UILabel()
        label.text = "공백 포함 10자 제한"
        label.font = .c4
        label.textColor = .gray400
        return label
    }()
    
    private let doubleCheckLabel: UILabel = {
        let label = UILabel()
        label.text = "이미 사용 중인 닉네임이에요 :("
        label.font = .c4
        label.textColor = .point
        label.isHidden = true
        return label
    }()
    
    private lazy var nextButton = SmeemButton(buttonType: .notEnabled, text: "다음")
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setDelegate()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.nicknameTextField.becomeFirstResponder()
    }
    
    // MARK: Methods
    
    private func bind() {
        nicknameTextField.textPublisher
            .sink { [weak self] text in
                self?.textFieldSubject.send(text)
            }
            .store(in: &cancelBag)
        
        nextButton.tapPublisher
            .sink { [weak self] _ in
                self?.nextButtonTapped.send((self?.nicknameTextField.text!)!)
            }
            .store(in: &cancelBag)
        
        let input = UserNicknameViewModel.Input(textFieldSubject: textFieldSubject,
                                                nextButtonTapped: nextButtonTapped)
        let output = viewModel.transform(input: input)
        
        output.textFieldResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] type in
                self?.nextButton.changeButtonType(buttonType: type)
            }
            .store(in: &cancelBag)
        
        output.nextButtonResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let serviceVC = ServiceAcceptViewController(nickname: (self?.nicknameTextField.text!)!)
                self?.navigationController?.pushViewController(serviceVC, animated: true)
            }
            .store(in: &cancelBag)
        
        output.nicknameDuplicateResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.doubleCheckLabel.isHidden = false
                self?.nextButton.changeButtonType(buttonType: .enabled)
            }
            .store(in: &cancelBag)
        
        output.loadingViewResult
            .receive(on: DispatchQueue.main)
            .sink { isShown in
                isShown ? SmeemLoadingView.showLoading() : SmeemLoadingView.hideLoading()
            }
            .store(in: &cancelBag)
        
        output.errorResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showToast(toastType: .smeemErrorToast(message: error))
            }
            .store(in: &cancelBag)
    }
    
    private func setDelegate() {
        self.nicknameTextField.delegate = self
    }
}

// MARK: - UITextFieldDelegate

extension UserNicknameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return true }
        
        // 현재 입력된 텍스트와 입력될 문자열을 합쳐서 새로운 텍스트 길이를 계산
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // 새로운 텍스트 길이가 10자 이하면 입력 허용
        return newText.count <= 10
    }
}

// MARK: - Layout

extension UserNicknameViewController {
    private func setLayout() {
        view.addSubviews(titleNicknameLabel, detailNicknameLabel, nicknameTextField, nicknameLimitLabel,
                         doubleCheckLabel, nextButton)
        
        titleNicknameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(convertByHeightRatio(120))
            $0.leading.equalToSuperview().inset(convertByHeightRatio(26))
        }
        
        detailNicknameLabel.snp.makeConstraints {
            $0.top.equalTo(titleNicknameLabel.snp.bottom).offset(convertByHeightRatio(6))
            $0.leading.equalToSuperview().inset(convertByHeightRatio(26))
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(detailNicknameLabel.snp.bottom).offset(convertByHeightRatio(28))
            $0.leading.trailing.equalToSuperview().inset(convertByHeightRatio(26))
            $0.height.equalTo(convertByHeightRatio(60))
        }
        
        doubleCheckLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(convertByHeightRatio(10))
            $0.leading.equalToSuperview().inset(convertByHeightRatio(26))
        }
        
        nicknameLimitLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(convertByHeightRatio(10))
            $0.trailing.equalToSuperview().inset(convertByHeightRatio(26))
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(convertByHeightRatio(18))
            $0.height.equalTo(convertByHeightRatio(60))
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-10)
        }
    }
}
