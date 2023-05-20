//
//  UserNickNameViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/17.
//

import UIKit

final class UserNicknameViewController: UIViewController {
    
    // MARK: - Property
    
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
    
    private let nextButton: SmeemButton = {
        let button = SmeemButton()
        button.setTitle("다음", for: .normal)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        setLayout()
        setTextFieldDelegate()
        showKeyboard(textView: nicknameTextField)
    }

    // MARK: - @objc
    
    // MARK: - Custom Method
    
    private func setTextFieldDelegate() {
        nicknameTextField.delegate = self
    }

    // MARK: - Layout
    
    private func setBackgroundColor() {
        view.backgroundColor = .smeemWhite
    }

    private func setLayout() {
        view.addSubviews(titleNicknameLabel, detailNicknameLabel, nicknameTextField, nicknameLimitLabel,
                         nextButton)
        
        titleNicknameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(120)
            $0.leading.equalToSuperview().inset(26)
        }
        
        detailNicknameLabel.snp.makeConstraints {
            $0.top.equalTo(titleNicknameLabel.snp.bottom).offset(6)
            $0.leading.equalToSuperview().inset(26)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.top.equalTo(detailNicknameLabel.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(convertByHeightRatio(60))
        }
        
        nicknameLimitLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(convertByHeightRatio(60))
            $0.bottom.equalToSuperview().inset(336+10)
        }
    }
}

// MARK: - UITextFieldDelegate

extension UserNicknameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
               let isBackSpace = strcmp(char, "\\b")
               if isBackSpace == -92 {
                   return true
               }
         }
        
        guard self.nicknameTextField.text?.count ?? 0 < 10 else { return false }
        return true
    }
}
