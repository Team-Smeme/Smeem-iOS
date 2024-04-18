//
//  SmeemStartViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/06.
//

import UIKit
import Combine

import SnapKit

final class SmeemStartViewController: BaseViewController {
    
    private let viewModel = SmeemStartViewModel()
    
    // MARK: Publisher
    
    private let loginButtonTapped = PassthroughSubject<Void, Never>()
    private let startButtonTapped = PassthroughSubject<Void, Never>()
    private let amplitudeSubject = PassthroughSubject<Void, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    // MARK: UI Properties
    
    private let SmeemLogoIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constant.Image.logoPointSmeem
        return imageView
    }()
    
    private let SmeemNameLabel: UILabel = {
        let label = UILabel()
        label.text = "smeem"
        label.font = .u1
        label.textColor = .black
        return label
    }()
    
    private let SmeemDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = """
                     일기로 시작하는 영어 아웃풋 훈련,
                     스밈입니다.
                     """
        label.numberOfLines = 2
        label.textColor = .black
        label.font = .b4
        label.setTextWithLineHeight(lineHeight: 22)
       return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .b4
        button.setTitle("이미 계정이 있으신가요?", for: .normal)
        button.setTitleColor(.gray600, for: .normal)
        return button
    }()
    
    private lazy var startButton: SmeemButton = {
        let button = SmeemButton(buttonType: .enabled, text: "시작하기")
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        amplitudeSubject.send(())
    }
    
    // MARK: Methods
    
    private func bind() {
        loginButton.tapPublisher
            .sink { [weak self] _ in
                self?.loginButtonTapped.send(())
            }
            .store(in: &cancelBag)
        
        startButton.tapPublisher
            .sink { [weak self] _ in
                self?.startButtonTapped.send(())
            }
            .store(in: &cancelBag)
        
        let input = SmeemStartViewModel.Input(loginButtonTapped: loginButtonTapped,
                                              startButtonTapped: startButtonTapped,
                                              amplitudeSubject: amplitudeSubject)
        let output = viewModel.transform(input: input)
        
        output.loginButtonTapped
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let loginBottomSheetVC = LoginBottomSheetViewController()
                let navigationController = UINavigationController(rootViewController: loginBottomSheetVC)
                navigationController.modalPresentationStyle = .overFullScreen
                
                self?.present(navigationController, animated: false) {
                    loginBottomSheetVC.bottomSheetView.frame.origin.y = self?.view.frame.height ?? 0
                    UIView.animate(withDuration: 0.3) {
                        loginBottomSheetVC.bottomSheetView.frame.origin.y = self!.view.frame.height-282
                    }
                }
            }
            .store(in: &cancelBag)
        
        output.startButtonTapped
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let trainingGoalsVC = TrainingGoalViewController()
                self?.navigationController?.pushViewController(trainingGoalsVC, animated: true)
            }
            .store(in: &cancelBag)
    }
    
    private func setLayout() {
        view.addSubviews(SmeemLogoIcon, SmeemNameLabel, SmeemDescriptionLabel,
                         loginButton, startButton)
        
        SmeemLogoIcon.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(149)
            $0.leading.equalToSuperview().inset(26)
        }
        
        SmeemNameLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(141)
            $0.leading.equalTo(SmeemLogoIcon.snp.trailing).offset(5)
        }
        
        SmeemDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(SmeemLogoIcon.snp.bottom).offset(17)
            $0.leading.equalToSuperview().inset(26)
        }
        
        loginButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(60)
            $0.bottom.equalTo(startButton.snp.top).offset(-10)
            $0.height.equalTo(43)
        }
        
        startButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(46)
            $0.height.equalTo(60)
        }
    }
}
