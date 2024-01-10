//
//  EditNicknameViewController.swift
//  Smeem-iOS
//
//  Created by JH on 2023/05/31.
//

import UIKit

import SnapKit

protocol EditMypageDelegate: AnyObject {
    func editMyPageData()
}

final class EditNicknameViewController: BaseViewController {
    
    // MARK: - Property
    
    private let editNicknameManager: MyPageEditManagerProtocol
    private let nicknameValidManager: NicknameValidManagerProtocol
    
    weak var editNicknameDelegate: EditMypageDelegate?
    
    var nickName = String()
    var checkDouble = Bool()
    var isExistNinkname = Bool()
    
    // MARK: - UI Property
    
    private let headerContainerView = UIView()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnBack, for: .normal)
        button.addTarget(self, action: #selector(backButtonDidTap(_:)), for: .touchUpInside)
        return button
    }()
    // TODO: setImage, addTarget 넣기
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임 변경"
        label.font = .s2
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
        textField.layer.cornerRadius = 6
        textField.layer.borderWidth = 1.5
        textField.layer.borderColor = UIColor.gray100.cgColor
        textField.layer.masksToBounds = true
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
    
    private lazy var doneButton: SmeemButton = {
        let button = SmeemButton(buttonType: .enabled, text: "완료")
        button.isEnabled = true
        button.backgroundColor = .point
        button.addTarget(self, action: #selector(doneButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let loadingView = LoadingView()
    
    // MARK: - Life Cycle
    
    init(editNicknameManager: MyPageEditManagerProtocol, nicknameValidManager: NicknameValidManagerProtocol) {
        self.editNicknameManager = editNicknameManager
        self.nicknameValidManager = nicknameValidManager
        
        super.init(nibName: nil , bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setData()
        setLayout()
        setTextFieldDelegate()
        showKeyboard(textView: nicknameTextField)
        addTextFieldNotification()
    }
    
    deinit {
        removeTextFieldNotification()
    }

    // MARK: - @objc
    
    @objc func backButtonDidTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func doneButtonDidTap() {
        validateNicknameAPI(nickname: nicknameTextField.text ?? "")
    }
    
    @objc func nicknameDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            if let text = textField.text {
                if text.first == " " {
                    doneButton.changeButtonType(buttonType: .notEnabled)
                } else if text.filter({ $0 == " " }).count == text.count {
                    doneButton.changeButtonType(buttonType: .notEnabled)
                } else {
                    doneButton.changeButtonType(buttonType: .enabled)
                }
            }
        }
    }

    // MARK: - Custom Method
    
    private func setTextFieldDelegate() {
        nicknameTextField.delegate = self
    }
    
    private func addTextFieldNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(nicknameDidChange),
                                               name: UITextField.textDidChangeNotification,
                                               object: nicknameTextField)
    }
    
    private func removeTextFieldNotification() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UITextField.textDidChangeNotification,
                                                  object: nicknameTextField)
    }
    
    private func setData() {
        nicknameTextField.text = nickName
    }

    // MARK: - Layout
    
    private func setLayout() {
        view.addSubviews(headerContainerView,
                         nicknameTextField,
                         nicknameLimitLabel,
                         doubleCheckLabel,
                         doneButton)
        headerContainerView.addSubviews(backButton, titleLabel)
        
        headerContainerView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(convertByHeightRatio(66))
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.width.height.equalTo(55)
        }
        
        titleLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(headerContainerView.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(convertByHeightRatio(66))
        }
        
        doubleCheckLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(convertByHeightRatio(10))
            $0.leading.equalToSuperview().inset(convertByHeightRatio(26))
        }
        
        nicknameLimitLabel.snp.makeConstraints{
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(10)
            $0.trailing.equalTo(nicknameTextField)
        }
        
        doneButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(convertByHeightRatio(60))
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-10)
        }
    }
}

// MARK: - UITextField Delegate

extension EditNicknameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = self.nicknameTextField.text else { return false }
        let maxLength = 10
        let newText = (text as NSString).replacingCharacters(in: range, with: string)
        
        if newText.count > maxLength {
            // 길이가 제한을 초과하면 입력을 막음
            return false
        }
        
        return true
    }
}


// MARK: - Extension : Network

extension EditNicknameViewController: ViewControllerServiceable {
    private func editNicknameAPI(nickname: String) {
        showLoadingView()
        Task {
            do {
                try await editNicknameManager.editNickname(model: EditNicknameRequest(username: nickname))
                hideLoadingView()
                self.editNicknameDelegate?.editMyPageData()
                self.navigationController?.popViewController(animated: true)
            } catch {
                guard let error = error as? NetworkError else { return }
                handlerError(error)
            }
        }
    }
    
    private func validateNicknameAPI(nickname: String) {
        showLoadingView()
        
        Task {
            do {
                let isExistNickname = try await nicknameValidManager.nicknameValid(param: nickname)
                
                hideLoadingView()
                
                if isExistNickname {
                    self.doubleCheckLabel.isHidden = false
                    self.doneButton.changeButtonType(buttonType: .notEnabled)
                } else {
                    self.doubleCheckLabel.isHidden = true
                    self.doneButton.changeButtonType(buttonType: .enabled)
                }
                
                if !isExistNickname {
                    showLoadingView()
                    editNicknameAPI(nickname: nickname)
                }
            } catch {
                guard let error = error as? NetworkError else { return }
                handlerError(error)
            }
        }
    }
}
