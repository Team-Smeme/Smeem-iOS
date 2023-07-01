//
//  UserNickNameViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/17.
//

import UIKit

final class UserNicknameViewController: UIViewController {
    
    // MARK: - Property
    
    var userPlanRequest: UserPlanRequest?
    var checkDouble = Bool()
    var badgeListData: [PopupBadge]?
    
    // MARK: - UI Property
    
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
    
    private lazy var nextButton: SmeemButton = {
        let button = SmeemButton()
        button.smeemButtonType = .notEnabled
        button.setTitle("다음", for: .normal)
        button.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        setLayout()
        setTextFieldDelegate()
        showKeyboard(textView: nicknameTextField)
        addTextFieldNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userPlanPatchAPI(userPlan: userPlanRequest!)
    }
    
    deinit {
        removeTextFieldNotification()
    }

    // MARK: - @objc
    
    @objc func nextButtonDidTap() {
        nicknamePatchAPI(nickname: nicknameTextField.text ?? "")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            if self.checkDouble {
                let homeVC = HomeViewController()
                homeVC.badgePopupData = self.badgeListData ?? []
                self.changeRootViewController(homeVC)
            } else {
                self.nextButton.smeemButtonType = .notEnabled
                self.doubleCheckLabel.isHidden = false
            }
        }
    }
    
    @objc func nicknameDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            if let text = textField.text {
                if text.first == " " {
                    nextButton.smeemButtonType = .notEnabled
                } else if text.filter({ $0 == " " }).count == text.count {
                    nextButton.smeemButtonType = .notEnabled
                } else {
                    nextButton.smeemButtonType = .enabled
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

    // MARK: - Layout
    
    private func setBackgroundColor() {
        view.backgroundColor = .smeemWhite
    }

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
            $0.bottom.equalToSuperview().inset(convertByHeightRatio(336+10))
        }
    }
}

extension UserNicknameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = self.nicknameTextField.text else { return false }
        let maxLength = 9
        
        if text.count > maxLength && range.length == 0 && range.location > maxLength {
            return false
        }
        
        return true
    }
}

extension UserNicknameViewController {
    private func nicknamePatchAPI(nickname: String) {
        OnboardingAPI.shared.nicknamePatch(param: NicknameRequest(username: nickname)) { response in
            self.checkDouble = response.success
        }
    }
    
    private func userPlanPatchAPI(userPlan: UserPlanRequest) {
        OnboardingAPI.shared.userPlanPathch(param: userPlan) { response in
            print(response.message)
            print(response.success)
        }
    }
}
