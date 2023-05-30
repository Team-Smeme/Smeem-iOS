//
//  ForeignDiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/05/10.
//

import UIKit

import SnapKit

final class ForeignDiaryViewController: UIViewController {
    
    // MARK: - Property
    
    // MARK: - UI Property
    
    private let naviView = UIView()
    private let navibarContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 110
        return stackView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .b4
        button.setTitleColor(.black, for: .normal)
        button.setTitle("취소", for: .normal)
        button.addTarget(self, action: #selector(naviButtonDidTap), for: .touchUpInside)
        return button
    }()

    private let languageLabel: UILabel = {
        let label = UILabel()
        label.font = .s2
        label.textColor = .smeemBlack
        label.text = "English"
        return label
    }()
    
    private lazy var completeButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .b4
        button.setTitleColor(.gray400, for: .normal)
        button.setTitle("완료", for: .normal)
        button.addTarget(self, action: #selector(completionButtonDidTap), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private var randomSubjectView: RandomSubjectView = {
        let view = RandomSubjectView()
//        view.configure(with: RandomSubjectViewModel(contentText: "", isHiddenRefreshButton: true))
        return view
    }()

    private lazy var diaryTextView: UITextView = {
        let textView = UITextView()
        textView.setLineSpacing()
        textView.textColor = .gray400
//        textView.delegate = self
        return textView
    }()

    private let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.text = "일기를 작성해주세요."
        label.textColor = .gray400
        label.font = .b4
        label.setTextWithLineHeight(lineHeight: 21)
        return label
    }()

    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    private let thinLine = SeparationLine(height: .thin)

    private lazy var randomTopicButton: UIButton = {
        let button = UIButton()
//        button.setImage(Constant.Image.btnRandomTopicCheckBox, for: .normal)
        button.addTarget(self, action: #selector(randomTopicButtonDidTap), for: .touchUpInside)
        button.backgroundColor = .point
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hiddenNavigationBar()
        setBackgoundColor()
        setLayout()
    }
    
    // MARK: - @objc
    
    @objc func randomTopicButtonDidTap(_ gesture: UITapGestureRecognizer) {
//        setRandomTopicButtonToggle()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        handleKeyboardChanged(notification: notification, customView: bottomView, isActive: true)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        handleKeyboardChanged(notification: notification, customView: bottomView, isActive: false)
    }
    
    @objc func naviButtonDidTap() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func completionButtonDidTap() {
//        changeMainRootViewController()
    }
    
    // MARK: - Custom Method
    
    private func setBackgoundColor() {
        view.backgroundColor = .smeemWhite
    }
    
    private func setLayout() {
        view.addSubviews(naviView, diaryTextView, bottomView)
        naviView.addSubview(navibarContentStackView)
        navibarContentStackView.addArrangedSubviews(cancelButton, languageLabel, completeButton)
        diaryTextView.addSubview(placeHolderLabel)
        bottomView.addSubviews(thinLine, randomTopicButton)
        
        naviView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(convertByHeightRatio(66))
        }
        
        navibarContentStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().offset(convertByWidthRatio(18))
        }
        
        diaryTextView.snp.makeConstraints {
            $0.top.equalTo(naviView.snp.bottom).offset(convertByHeightRatio(10))
            $0.centerX.equalToSuperview()
            $0.leading.equalTo(navibarContentStackView)
            $0.bottom.equalTo(bottomView.snp.top)
        }
        
        placeHolderLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(constraintByNotch(87, 53))
        }
        
        thinLine.snp.makeConstraints {
            $0.bottom.equalTo(bottomView.snp.top)
        }
        
        randomTopicButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(convertByHeightRatio(18))
            $0.trailing.equalToSuperview().offset(convertByWidthRatio(-30))
        }
    }
}

// MARK: - UITextViewDelegate

// MARK: - Network
