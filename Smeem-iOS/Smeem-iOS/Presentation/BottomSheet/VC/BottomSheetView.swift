//
//  BottomSheetView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/06.
//

import UIKit

import SnapKit

enum ViewType {
    case login
    case signUp
}

protocol LoginDelegate {
    func kakaoLoginDataSend()
    func appleLoginDataSend()
    func dismissBottomSheet()
}

final class BottomSheetView: UIView {
    
    // MARK: - viewType
    
    var viewType: ViewType = .login {
        didSet {
            setBottomSheetLayout()
        }
    }
    
    var delegate: LoginDelegate?
    
    // MARK: - UI Property
    
    private let bottomSheetLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인"
        label.textColor = .black
        label.font = .h3
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnCancelGrey, for: .normal)
        button.addTarget(self, action: #selector(cancleButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.btnKakaoLogin, for: .normal)
        button.addTarget(self, action: #selector(kakaoLoginButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var appleLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.btnAppleLogin, for: .normal)
        button.addTarget(self, action: #selector(appleLoginButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let guestLoginButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.gray600, for: .normal)
        button.titleLabel?.font = .b4
        button.setTitle("비회원으로 시작하기", for: .normal)
        return button
    }()
    
    private let guestLoginTooltip: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constant.Image.btnNonMember
        return imageView
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - @objc
    
    @objc func kakaoLoginButtonDidTap() {
        delegate?.kakaoLoginDataSend()
    }
    
    @objc func appleLoginButtonDidTap() {
        delegate?.appleLoginDataSend()
    }
    
    @objc func cancleButtonDidTap() {
        delegate?.dismissBottomSheet()
    }
    
    // MARK: - Custom Method
    
    private func setUI() {
        backgroundColor = .white
        makeSelectedRoundCorners(cornerRadius: 30, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
    }
    
    private func setLayout() {
        addSubviews(bottomSheetLabel, cancelButton, kakaoLoginButton, appleLoginButton, guestLoginButton, guestLoginTooltip)
        
        cancelButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.width.height.equalTo(40)
        }
        
        bottomSheetLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(26)
            $0.top.equalToSuperview().inset(56)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.top.equalTo(bottomSheetLabel.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(kakaoLoginButton.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func setBottomSheetLayout() {
        switch viewType {
        case .login:
            bottomSheetLabel.text = "로그인"
            guestLoginButton.isHidden = true
        case .signUp:
//            bottomSheetLabel.text = "회원가입"
//
//            guestLoginButton.snp.makeConstraints {
//                $0.top.equalTo(appleLoginButton.snp.bottom).offset(22)
//                $0.centerX.equalToSuperview()
//            }
//
//            guestLoginTooltip.snp.makeConstraints {
//                $0.top.equalTo(guestLoginButton.snp.bottom).offset(3)
//                $0.centerX.equalToSuperview()
//            }
            bottomSheetLabel.text = "회원가입"
            guestLoginButton.isHidden = true
        }
    }
}
