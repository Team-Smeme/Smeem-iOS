//
//  LoginBottomSheetViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/06.
//

import UIKit
import Combine

import SnapKit
import AuthenticationServices

final class LoginBottomSheetViewController: UIViewController {
    
    private let viewModel = LoginViewModel()
    
    // MARK: Publisher
    
    private let kakaoLoginTapped = PassthroughSubject<Void, Never>()
    private let appleLoginTapped = PassthroughSubject<Void, Never>()
    private let appleLoginSubject = PassthroughSubject<String, Never>()
    private let dismissTapped = PassthroughSubject<Void, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    // MARK: UI Properties
    
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor(red: 0.09, green: 0.09, blue: 0.086, alpha: 0.65).cgColor
        return view
    }()
    
    var bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .smeemWhite
        view.makeSelectedRoundCorners(cornerRadius: 30, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        return view
    }()
    
    private let bottomSheetLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인"
        label.textColor = .black
        label.font = .h3
        return label
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnCancelGrey, for: .normal)
        return button
    }()
    
    private lazy var kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.btnKakaoLogin, for: .normal)
        return button
    }()
    
    private lazy var appleLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.btnAppleLogin, for: .normal)
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        setLayout()
        bind()
    }
    
    // MARK: - Method
    
    private func bind() {
        kakaoLoginButton.tapPublisher
            .sink { _ in
                self.kakaoLoginTapped.send(())
            }
            .store(in: &cancelBag)
        
        appleLoginButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let request = appleIDProvider.createRequest()
                request.requestedScopes = []
                
                let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                authorizationController.delegate = self
                authorizationController.presentationContextProvider = self
                authorizationController.performRequests()
            }
            .store(in: &cancelBag)
        
        dismissButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                UIView.animate(withDuration: 0.3, animations: {
                    self?.bottomSheetView.frame.origin.y = (self?.view.frame.height)!
                }) { _ in
                    self?.dismiss(animated: false, completion: nil)
                }
            }
            .store(in: &cancelBag)
        
        dimmedView.gesturePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                UIView.animate(withDuration: 0.3, animations: {
                    self?.bottomSheetView.frame.origin.y = (self?.view.frame.height)!
                }) { _ in
                    self?.dismiss(animated: false, completion: nil)
                }
            }
            .store(in: &cancelBag)
        
        let input = LoginViewModel.Input(kakaoLoginTapped: kakaoLoginTapped,
                                         appleLoginSubject: appleLoginSubject,
                                         dismissTapped: dismissTapped)
        let output = viewModel.transform(input: input)
        
        output.presentHomeResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.changeRootViewController(HomeViewController())
            }
            .store(in: &cancelBag)
        
        output.presentTrainingResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let trainingVC = TrainingGoalViewController()
                self?.navigationController?.pushViewController(trainingVC, animated: true)
            }
            .store(in: &cancelBag)
        
        output.presentServiceResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let nicknameVC = UserNicknameViewController()
                self?.navigationController?.pushViewController(nicknameVC, animated: true)
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
    
    private func setBackgroundColor() {
        view.backgroundColor = .clear
    }
}

// MARK: - Apple Login

extension LoginBottomSheetViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window!
    }
    
    // 사용자 인증 후 처리
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let _ = appleIDCredential.user
            let idToken = appleIDCredential.identityToken!
            guard let appleTokenString = String(data: idToken, encoding: .utf8) else { return }
            
            appleLoginSubject.send(appleTokenString)
            
        default:
            break
        }
    }
    
    // 사용자 인증 실패했을 때
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print(error.localizedDescription)
    }
}

// MARK: - Layout

extension LoginBottomSheetViewController {
    private func setLayout() {
        view.addSubviews(dimmedView, bottomSheetView)
        bottomSheetView.addSubviews(bottomSheetLabel, dismissButton, kakaoLoginButton, appleLoginButton)
        
        dimmedView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        bottomSheetView.snp.makeConstraints {
            $0.height.equalTo(282)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        dismissButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.width.height.equalTo(55)
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
}
