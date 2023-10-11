//
//  UserNickNameViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/17.
//

import UIKit

final class UserNicknameViewController: UIViewController {
    
    // MARK: - Property
    
    var userPlanRequest: UserTrainingInfoRequest?
    var isExistNinkname = Bool()
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
        let button = SmeemButton(buttonType: .notEnabled, text: "다음")
        button.addTarget(self, action: #selector(nextButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let loadingView = LoadingView()
    
    private let welcomeView = UIImageView()
    private let firstDiaryView = UIImageView()
    private let tenDiaryBadgeView = UIImageView()
    private let day3BadgeView = UIImageView()
    private let day7BadgeView = UIImageView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        setLayout()
        setTextFieldDelegate()
        showKeyboard(textView: nicknameTextField)
        addTextFieldNotification()
        setImage()
        hiddenNavigationBar()
    }
    
    deinit {
        removeTextFieldNotification()
    }

    // MARK: - @objc
    
    @objc func nextButtonDidTap() {
        self.showLodingView(loadingView: loadingView)
        checkNicknameGetAPI(nickname: nicknameTextField.text ?? "")
    }
    
    @objc func nicknameDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            if let text = textField.text {
                if text.first == " " {
                    nextButton.changeButtonType(buttonType: .notEnabled)
                } else if text.filter({ $0 == " " }).count == text.count {
                    nextButton.changeButtonType(buttonType: .notEnabled)
                } else {
                    nextButton.changeButtonType(buttonType: .enabled)
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
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-10)
        }
    }
    
    private func setImage() {
        let welcomeBadge = URL(string: "https://github.com/Team-Smeme/Smeme-plan/assets/120551217/6b3319cb-4c6f-4bf2-86dd-7576a44b46c7")
        let firstDiarybadge = URL(string: "https://github.com/Team-Smeme/Smeme-plan/assets/120551217/10ed4dd9-276a-4344-87a8-f39b91deebd5")
        let tenDiaryBadge = URL(string: "https://github.com/Team-Smeme/Smeme-plan/assets/120551217/645082e3-9c25-4698-b614-b575b75be188")
        let day3Badge = URL(string: "https://github.com/Team-Smeme/Smeme-plan/assets/120551217/3b26b274-722f-4dca-a560-e28c266efe69")
        let day7Badge = URL(string: "https://github.com/Team-Smeme/Smeme-plan/assets/120551217/9f0c9af4-fd5e-4436-adac-7755312f00de")
        
        welcomeView.kf.setImage(with: welcomeBadge)
        firstDiaryView.kf.setImage(with: firstDiarybadge)
        tenDiaryBadgeView.kf.setImage(with: tenDiaryBadge)
        day3BadgeView.kf.setImage(with: day3Badge)
        day7BadgeView.kf.setImage(with: day7Badge)
    }
}

extension UserNicknameViewController: UITextFieldDelegate {
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

extension UserNicknameViewController {
    private func checkNicknameGetAPI(nickname: String) {
        OnboardingAPI.shared.ninknameCheckAPI(userName: nickname, accessToken: UserDefaultsManager.clientAccessToken) { response in
            guard let data = response.data else { return }
            
            self.hideLodingView(loadingView: self.loadingView)
            self.isExistNinkname = data.isExist
            
            if self.isExistNinkname {
                self.doubleCheckLabel.isHidden = false
                self.nextButton.changeButtonType(buttonType: .notEnabled)
            } else {
                self.doubleCheckLabel.isHidden = true
                self.nextButton.changeButtonType(buttonType: .enabled)
            }
            
            if !self.isExistNinkname {
                let serviceVC = ServiceAcceptViewController()
                serviceVC.nickNameData = self.nicknameTextField.text ?? ""
                self.navigationController?.pushViewController(serviceVC, animated: true)
            }
        }
    }
    
//    private func userPlanPatchAPI(userPlan: UserPlanRequest) {
//        OnboardingAPI.shared.userPlanPathch(param: userPlan) { response in
//            print(response.message)
//            print(response.success)
//        }
//    }
}
