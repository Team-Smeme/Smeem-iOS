//
//  EditNicknameViewController.swift
//  Smeem-iOS
//
//  Created by JH on 2023/05/31.
//

import UIKit

import SnapKit

class EditNicknameViewController: UIViewController {
    
    // MARK: - Property
    
    var nickName = String()
    var checkDouble = Bool()
    
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
        let button = SmeemButton()
        button.setTitle("완료", for: .normal)
        button.isEnabled = true
        button.backgroundColor = .point
        button.addTarget(self, action: #selector(doneButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let loadingView = LoadingView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setData()
        setBackgroundColor()
        setLayout()
        hiddenNavigationBar()
        setTextFieldDelegate()
        showKeyboard(textView: nicknameTextField)
        addTextFieldNotification()
    }
    
    deinit {
        removeTextFieldNotification()
    }

    // MARK: - @objc
    
//    @objc private func textFieldEditingChanged(_ textField: UITextField) {
//        if let text = textField.text, !text.isEmpty {
//            doneButton.isEnabled = true // 텍스트 필드에 텍스트가 입력되었을 때 버튼 활성화
//            doneButton.backgroundColor = .point
//        } else {
//            doneButton.isEnabled = false // 텍스트 필드가 비어있을 때 버튼 비활성화
//            doneButton.backgroundColor = .pointInactive
//        }
//    }
    
    @objc func backButtonDidTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
//    @objc func doneButtonDidTap(_ sender: UIButton) {
//        changeMyName(userName: nicknameTextField.text ?? nickName)
//        changeRootViewController(HomeViewController())
//    }
    
    @objc func doneButtonDidTap() {
        self.showLodingView(loadingView: self.loadingView)
        nicknamePatchAPI(nickname: nicknameTextField.text ?? "")
    }
    
    @objc func nicknameDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            if let text = textField.text {
                if text.first == " " {
                    doneButton.smeemButtonType = .notEnabled
                } else if text.filter({ $0 == " " }).count == text.count {
                    doneButton.smeemButtonType = .notEnabled
                } else {
                    doneButton.smeemButtonType = .enabled
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
 
    private func setBackgroundColor() {
        view.backgroundColor = .smeemWhite
    }
    
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
            $0.width.height.equalTo(45)
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
            $0.bottom.equalToSuperview().inset(336+10)
        }
    }
}

// MARK: - UITextField Delegate

extension EditNicknameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = self.nicknameTextField.text else { return false }
        let maxLength = 9
        
        if text.count > maxLength && range.length == 0 && range.location > maxLength {
            return false
        }
        
        return true
    }
}


// MARK: - Extension : Network

extension EditNicknameViewController {
    private func nicknamePatchAPI(nickname: String) {
        OnboardingAPI.shared.nicknamePatch(param: NicknameRequest(username: nickname)) { response in
            self.checkDouble = response.success
            self.hideLodingView(loadingView: self.loadingView)
            
            DispatchQueue.main.async {
                if self.checkDouble {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.doneButton.smeemButtonType = .notEnabled
                    self.doubleCheckLabel.isHidden = false
                }
            }
        }
    }
}
