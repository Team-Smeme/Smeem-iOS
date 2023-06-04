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
    
    private var randomTopicEnabled: Bool = false {
        didSet {
            updateRandomTopicView()
            updateInputTextViewConstraints()
            view.layoutIfNeeded()
        }
    }
    
    // MARK: - UI Property
    
    private let navigationView = UIView()
    private lazy var randomSubjectView = RandomSubjectView()
    
    private let navibarContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        // FIXME: 기기대응시 문제가 생길수도..?
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
        button.titleLabel?.font = .b1
        button.setTitleColor(.gray300, for: .normal)
        button.setTitle("완료", for: .normal)
        button.isEnabled = false
        return button
    }()
    
    private lazy var inputTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .smeemBlack
        textView.font = .b4
        textView.tintColor = .point
        textView.delegate = self
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
        button.addTarget(self, action: #selector(randomTopicButtonDidTap), for: .touchUpInside)
        button.backgroundColor = .point
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showKeyboard(textView: inputTextView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hiddenNavigationBar()
        setBackgroundColor()
        setLayout()
    }
    
    // MARK: - @objc
    
    @objc func randomTopicButtonDidTap(_ gesture: UITapGestureRecognizer) {
        setRandomTopicButtonToggle()
    }
    
    @objc func naviButtonDidTap() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Custom Method
    
    private func setBackgroundColor() {
        view.backgroundColor = .smeemWhite
    }
    
    private func setRandomTopicButtonToggle() {
        randomTopicEnabled.toggle()
    }
    
    private func characterValidation() -> Bool {
        while inputTextView.text.getArrayAfterRegex(regex: "[a-zA-z]").count > 9 {
            return true
        }
        return false
    }
    
    private func updateRandomTopicView() {
        if randomTopicEnabled {
            view.addSubview(randomSubjectView)
            randomSubjectView.snp.makeConstraints {
                $0.top.equalTo(navigationView.snp.bottom).offset(convertByHeightRatio(16))
                $0.leading.equalToSuperview()
            }
        } else {
            randomSubjectView.removeFromSuperview()
        }
    }
    
    private func updateInputTextViewConstraints() {
        inputTextView.snp.remakeConstraints {
            $0.top.equalTo(randomTopicEnabled ? randomSubjectView.snp.bottom : navigationView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(convertByWidthRatio(18))
            $0.bottom.equalTo(bottomView.snp.top)
        }
    }
    
    //MARK: - Layout
    
    private func setLayout() {
        view.addSubviews(navigationView, inputTextView, bottomView)
        navigationView.addSubview(navibarContentStackView)
        navibarContentStackView.addArrangedSubviews(cancelButton, languageLabel, completeButton)
        inputTextView.addSubview(placeHolderLabel)
        bottomView.addSubviews(thinLine, randomTopicButton)
        
        navigationView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(convertByHeightRatio(66))
        }
        
        navibarContentStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().offset(convertByWidthRatio(18))
        }
        
        inputTextView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(convertByHeightRatio(10))
            $0.centerX.equalToSuperview()
            $0.leading.equalTo(navibarContentStackView)
            $0.bottom.equalTo(bottomView.snp.top)
        }
        
        placeHolderLabel.snp.makeConstraints {
            $0.centerY.equalTo(inputTextView.textInputView)
            $0.leading.equalToSuperview().offset(convertByWidthRatio(4))
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

extension ForeignDiaryViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let isTextEmpty = textView.text.isEmpty
        placeHolderLabel.isHidden = !isTextEmpty
        completeButton.isEnabled = characterValidation()
        completeButton.setTitleColor(completeButton.isEnabled ? .point : .gray400, for: .normal)
    }
}

// MARK: - Network
