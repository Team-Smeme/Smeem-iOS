//
//  DiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/04.
//

import UIKit

import SnapKit

protocol DiaryStrategy {
    func configureLanguageLabel(_ label: UILabel)
    func configureRightNavigationButton(_ button: UIButton)
    func configureStepLabel(_ label: UILabel)
    func configureRandomSubjectButton(_ button: UIButton)
}

class DiaryViewController: UIViewController {
    
    // MARK: - Property
    
    var diaryStrategy: DiaryStrategy?
    
    private weak var delegate: UITextViewDelegate?
    
    private var randomTopicEnabled: Bool = false {
        didSet {
            updateRandomTopicView()
            updateInputTextViewConstraints()
            view.layoutIfNeeded()
        }
    }
    
    var topicID: Int?
    var topicContent = String()
    
    var isTopicCalled: Bool = false
    
    // MARK: - UI Property
    
    let navigationView = UIView()
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
        button.addTarget(self, action: #selector(leftNavigationButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.font = .s2
        label.textColor = .smeemBlack
        label.text = "Lang"
        return label
    }()
    
    private let stepLabel: UILabel = {
        let label = UILabel()
        label.font = .c4
        label.textColor = .gray500
        return label
    }()
    
    lazy var rightNavigationButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .b1
        button.setTitleColor(.gray300, for: .normal)
        button.setTitle("완료", for: .normal)
        button.addTarget(self, action: #selector(rightNavigationButtonDidTap) , for: .touchUpInside)
        return button
    }()
    
    lazy var inputTextView: UITextView = {
        let textView = UITextView()
        textView.configureDiaryTextView(topInset: 20)
        textView.configureTypingAttributes()
        textView.delegate = self
        return textView
    }()
    
    let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.text = "일기를 작성해주세요."
        label.textColor = .gray400
        label.font = .b4
        label.setTextWithLineHeight(lineHeight: 21)
        return label
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    private let thinLine = SeparationLine(height: .thin)
    
    lazy var randomSubjectButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(randomTopicButtonDidTap), for: .touchUpInside)
        button.backgroundColor = .point
        return button
    }()
    
    private var tutorialImageView: UIImageView? = {
        let imageView = UIImageView()
        imageView.image = Constant.Image.tutorialDiaryStepOne
        return imageView
    }()
    
    private lazy var dismissButton: UIButton? = {
        let button = UIButton()
        button.addTarget(self, action: #selector(dismissButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    let regExToastView = SmeemToastView(type: .defaultToast(bodyType: .regEx))
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardAddObserver()
        showKeyboard(textView: inputTextView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDiaryStrategy()
        configureUI()
        setupUI()
        setDelegate()
        checkTutorial()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        keyboardRemoveObserver()
    }
    
    deinit {
        randomSubjectView.removeFromSuperview()
        regExToastView.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - @objc
    
    @objc func randomTopicButtonDidTap() {
        setRandomTopicButtonToggle()
        if isTopicCalled {
            randomSubjectWithAPI()
            isTopicCalled = true
        }
    }
    
    @objc func leftNavigationButtonDidTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func rightNavigationButtonDidTap() {
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        
        let keyboardHeight = keyboardFrame.height
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        inputTextView.contentInset = insets
        inputTextView.scrollIndicatorInsets = insets
        self.bottomView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        inputTextView.contentInset = .zero
        inputTextView.scrollIndicatorInsets = .zero
        self.bottomView.transform = CGAffineTransform.identity
    }
    
    @objc func dismissButtonDidTap() {
        tutorialImageView?.removeFromSuperview()
        dismissButton?.removeFromSuperview()
    }
    
    // MARK: - Custom Method
    
    private func setData() {
        randomSubjectView.configureData(contentText: topicContent)
    }
    
    private func setupUI() {
        hiddenNavigationBar()
        setBackgroundColor()
        setLayout()
    }
    
    private func setDelegate() {
        randomSubjectView.delegate = self
    }
    
    private func configureDiaryStrategy() {
        if self is ForeignDiaryViewController {
            diaryStrategy = ForeignDiaryStrategy()
        } else if self is StepOneKoreanDiaryViewController {
            diaryStrategy = StepOneKoreanDiaryStrategy()
        } else if self is StepTwoKoreanDiaryViewController {
            diaryStrategy = StepTwoKoreanDiaryStrategy()
        }
    }
    
    private func configureUI() {
        diaryStrategy?.configureLanguageLabel(languageLabel)
        diaryStrategy?.configureRightNavigationButton(rightNavigationButton)
        diaryStrategy?.configureStepLabel(stepLabel)
        diaryStrategy?.configureRandomSubjectButton(randomSubjectButton)
    }
    
    private func setBackgroundColor() {
        view.backgroundColor = .smeemWhite
    }
    
    private func setRandomTopicButtonToggle() {
        randomTopicEnabled.toggle()
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
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomView.snp.top)
        }
    }
    
    private func keyboardAddObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func keyboardRemoveObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Layout
    
    private func setLayout() {
        view.addSubviews(navigationView, inputTextView, bottomView)
        navigationView.addSubviews(navibarContentStackView, stepLabel)
        navibarContentStackView.addArrangedSubviews(cancelButton, languageLabel, rightNavigationButton)
        inputTextView.addSubview(placeHolderLabel)
        bottomView.addSubviews(thinLine, randomSubjectButton)
        
        navigationView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(convertByHeightRatio(66))
        }
        
        navibarContentStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().offset(convertByWidthRatio(18))
        }
        
        stepLabel.snp.makeConstraints {
            $0.top.equalTo(languageLabel.snp.bottom).offset(convertByWidthRatio(4))
            $0.centerX.equalToSuperview()
        }
        
        inputTextView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomView.snp.top)
        }
        
        placeHolderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(convertByHeightRatio(18))
            $0.leading.equalToSuperview().offset(convertByWidthRatio(20))
        }
        
        bottomView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(constraintByNotch(53, 87))
        }
        
        thinLine.snp.makeConstraints {
            $0.bottom.equalTo(bottomView.snp.top)
            $0.centerX.equalToSuperview()
        }
        
        randomSubjectButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(convertByHeightRatio(17))
            $0.trailing.equalToSuperview().offset(convertByWidthRatio(-18))
            $0.width.equalTo(convertByWidthRatio(78))
            $0.height.equalTo(convertByHeightRatio(19))
        }
    }
    
    private func checkTutorial() {
//        if self is StepOneKoreanDiaryViewController {
//            let tutorialDiaryStepOne = UserDefaultsManager.tutorialDiaryStepOne
//            
//            if !tutorialDiaryStepOne {
//                UserDefaultsManager.tutorialDiaryStepOne = true
//                
//                view.addSubviews(tutorialImageView ?? UIImageView(), dismissButton ?? UIButton())
//                
//                tutorialImageView?.snp.makeConstraints {
//                    $0.top.leading.trailing.bottom.equalToSuperview()
//                }
//                dismissButton?.snp.makeConstraints {
//                    $0.top.equalToSuperview().inset(convertByHeightRatio(204))
//                    $0.trailing.equalToSuperview().inset(convertByHeightRatio(10))
//                    $0.width.height.equalTo(convertByHeightRatio(45))
//                }
//            } else {
//                tutorialImageView = nil
//                dismissButton = nil
//            }
//        }
    }
}

// MARK: - UITextViewDelegate

extension DiaryViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let isTextEmpty = textView.text.isEmpty
        placeHolderLabel.isHidden = !isTextEmpty
        
        guard let strategy = diaryStrategy else {
            rightNavigationButton.setTitleColor(.gray400, for: .normal)
            return
        }
        
        if let koreanStrategy = strategy as? StepOneKoreanDiaryStrategy {
            rightNavigationButton.isEnabled = koreanStrategy.koreanValidation(with: textView.text, in: self)
        } else {
            rightNavigationButton.isEnabled = strategy.englishValidation(with: textView.text, in: self)
        }
        
        rightNavigationButton.setTitleColor(rightNavigationButton.isEnabled ? .point : .gray400, for: .normal)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        let cursorPosition = textView.selectedTextRange?.end
        if let cursorPosition = cursorPosition {
            let caretPositionRect = textView.caretRect(for: cursorPosition)
            textView.scrollRectToVisible(caretPositionRect, animated: true)
        }
    }
}

extension DiaryStrategy {
    func englishValidation(with text: String, in viewController: DiaryViewController) -> Bool {
        return viewController.inputTextView.text.getArrayAfterRegex(regex: "[a-zA-z]").count > 9
    }
    
}

extension StepOneKoreanDiaryStrategy {
    func koreanValidation(with text: String, in viewController: DiaryViewController) -> Bool {
        return viewController.inputTextView.text.getArrayAfterRegex(regex: "[가-핳ㄱ-ㅎㅏ-ㅣ]").count > 9
    }
}

//MARK: - RandomSubjectViewDelegate

extension DiaryViewController: RandomSubjectViewDelegate {
    func refreshButtonTapped() {
        randomSubjectWithAPI()
    }
}

// MARK: - Network

extension DiaryViewController {
    func randomSubjectWithAPI() {
        RandomSubjectAPI.shared.getRandomSubject { response in
            guard let randomSubjectData = response?.data else { return }
            self.topicID = randomSubjectData.topicId
            self.topicContent = randomSubjectData.content
            self.setData()
        }
    }
    
    func postDiaryAPI() {
        PostDiaryAPI.shared.postDiary(param: PostDiaryRequest(content: inputTextView.text, topicId: topicID)) { response in
//            guard let postDiaryResponse = response?.data else { return }
//            self.diaryID = postDiaryResponse.
        }
    }
}
