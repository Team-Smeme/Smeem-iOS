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

final class EditNicknameViewController: UIViewController {
    
    // MARK: - Property
    
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
        swipeRecognizer()
    }
    
    deinit {
        removeTextFieldNotification()
    }

    // MARK: - @objc
    
    @objc func backButtonDidTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func doneButtonDidTap() {
        self.showLodingView(loadingView: self.loadingView)
        checkNinknameAPI(nickname: nicknameTextField.text ?? "")
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
    
    @objc func responseToSwipeGesture() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func swipeRecognizer() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(responseToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
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

extension EditNicknameViewController {
    private func nicknamePatchAPI(nickname: String) {
        MyPageAPI.shared.changeMyNickName(request: EditNicknameRequest(username: nickname)) { response in
            guard let _ = response?.data else { return }
            self.hideLodingView(loadingView: self.loadingView)
            self.editNicknameDelegate?.editMyPageData()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func checkNinknameAPI(nickname: String) {
        MyPageAPI.shared.checkNinknameAPI(param: nickname) { response in
            guard let data = response?.data else { return }
            
            self.hideLodingView(loadingView: self.loadingView)
            self.isExistNinkname = data.isExist
            
            if self.isExistNinkname {
                self.doubleCheckLabel.isHidden = false
                self.doneButton.smeemButtonType = .notEnabled
            } else {
                self.doubleCheckLabel.isHidden = true
                self.doneButton.smeemButtonType = .enabled
            }
            
            if !self.isExistNinkname {
                self.showLodingView(loadingView: self.loadingView)
                self.nicknamePatchAPI(nickname: nickname)
            }
        }
    }
}
