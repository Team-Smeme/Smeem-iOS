//
//  DiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/04.
//

import UIKit

import SnapKit

protocol DiaryStrategy {
    func configureRandomSubjectButtonImage(_ button: UIButton)
    func configurePlaceHolder(_ textView: UITextView)
    func configureToolTipView(_ imageView: UIImageView)
    func configureRandomSubjectButton(_ button: UIButton)
    func configureLanguageLabel(_ label: UILabel)
    func configureLeftNavigationButton(_ button: UIButton)
    func configureRightNavigationButton(_ button: UIButton)
    func configureStepLabel(_ label: UILabel)
    
    var textViewPlaceholder: String { get }
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
    
    var topicID: Int? = nil
    var topicContent = String()
    var diaryID: Int?
    var badgePopupContent = [PopupBadge]()
    
    var isTopicCalled: Bool = false
    var isKeyboardVisible: Bool = false
    var keyboardHeight: CGFloat = 0.0
    var rightButtonFlag = false
    var isInitialInput = true
    
    // MARK: - UI Property
    
    let navigationView = UIView()
    private lazy var randomSubjectView = RandomSubjectView()
    let loadingView = LoadingView()
    
    private let navibarContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        // FIXME: 기기대응시 문제가 생길수도..?
        stackView.spacing = 110
        return stackView
    }()
    
    lazy var leftNavigationButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .b4
        button.setTitleColor(.black, for: .normal)
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
        textView.textContentType = .init(rawValue: "ko-KR")
        textView.delegate = self
        textView.textColor = .gray400
//        textView.text = textViewPlaceholder
        textView.selectedRange = NSRange(location: 0, length: 0)
        return textView
    }()
    
    let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    let thinLine = SeparationLine(height: .thin)
    
    lazy var randomSubjectButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(randomTopicButtonDidTap), for: .touchUpInside)
        button.setImage(Constant.Image.btnRandomSubjectInactive, for: .normal)
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
    
    lazy var randomSubjectToolTip: UIImageView? = {
        let image = UIImageView()
        image.image = Constant.Image.icnToolTip
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(randomSubjectToolTipDidTap))
        image.addGestureRecognizer(tapGesture)
        image.isUserInteractionEnabled = true
        return image
    }()
    
    var smeemToastView: SmeemToastView?
    
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
        checkTooltip()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        keyboardRemoveObserver()
        
        if let currentChildViewController = children.first {
            switch currentChildViewController {
            case is DiaryViewController:
                print("DiaryViewController")
            case is ForeignDiaryViewController:
                randomSubjectToolTip?.removeFromSuperview()
            case is StepOneKoreanDiaryViewController:
                print("StepOneKoreanDiaryViewController")
            case is StepTwoKoreanDiaryViewController:
                randomSubjectToolTip?.removeFromSuperview()
            default:
                break
            }
        }
    }
    
    deinit {
        randomSubjectView.removeFromSuperview()
        smeemToastView?.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - @objc
    
    @objc func randomTopicButtonDidTap() {
        if !UserDefaultsManager.randomSubjectToolTip {
            UserDefaultsManager.randomSubjectToolTip = true
            randomSubjectToolTip?.isHidden = true
        }
        
        setRandomTopicButtonToggle()
        
        if !isTopicCalled {
            randomSubjectWithAPI()
            randomSubjectButton.setImage(Constant.Image.btnRandomSubjectActive, for: .normal)
            isTopicCalled = true
        } else {
            isTopicCalled = false
            topicID = nil
        }
        randomSubjectView.setData(contentText: topicContent)
    }
    
    @objc func leftNavigationButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightNavigationButtonDidTap() {
        if !rightNavigationButton.isEnabled {
            showToastIfNeeded(toastType: .defaultToast(bodyType: .regEx))
        }
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
        
        self.keyboardHeight = keyboardFrame.height
        isKeyboardVisible = true
        
        UIView.animate(withDuration: 0.3) {
            self.bottomView.snp.updateConstraints {
                $0.height.equalTo(53)
            }
            self.view.layoutIfNeeded()
        }
        
        updateAdditionalViewsForKeyboard(notification: notification, keyboardHeight: keyboardHeight)
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        inputTextView.contentInset = .zero
        inputTextView.scrollIndicatorInsets = .zero
        self.bottomView.transform = CGAffineTransform.identity
        
        isKeyboardVisible = false
        
        UIView.animate(withDuration: 0.3) {
            self.bottomView.snp.updateConstraints {
                $0.height.equalTo(87)
            }
            self.view.layoutIfNeeded()
        }
        
        updateAdditionalViewsForKeyboard(notification: notification, keyboardHeight: 0)
    }
    
    @objc func dismissButtonDidTap() {
        tutorialImageView?.removeFromSuperview()
        dismissButton?.removeFromSuperview()
    }
    
    @objc func randomSubjectToolTipDidTap() {
        self.randomSubjectToolTip?.isHidden = true
        UserDefaultsManager.randomSubjectToolTip = true
    }
    
    // MARK: - Custom Method
    
    private func setData() {
        randomSubjectView.setData(contentText: topicContent)
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
        if let randomSubjectToolTip = randomSubjectToolTip {
            diaryStrategy?.configureToolTipView(randomSubjectToolTip)
        }
        
        diaryStrategy?.configureRandomSubjectButton(randomSubjectButton)
        diaryStrategy?.configurePlaceHolder(inputTextView)
        diaryStrategy?.configureRandomSubjectButton(randomSubjectButton)
        diaryStrategy?.configureLanguageLabel(languageLabel)
        diaryStrategy?.configureLeftNavigationButton(leftNavigationButton)
        diaryStrategy?.configureRightNavigationButton(rightNavigationButton)
        diaryStrategy?.configureStepLabel(stepLabel)
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
            randomSubjectButton.setImage(Constant.Image.btnRandomSubjectActive, for: .normal)
        } else {
            randomSubjectView.removeFromSuperview()
            randomSubjectButton.setImage(Constant.Image.btnRandomSubjectInactive, for: .normal)
        }
    }
    
    private func updateInputTextViewConstraints() {
        inputTextView.snp.remakeConstraints {
            $0.top.equalTo(randomTopicEnabled ? randomSubjectView.snp.bottom : navigationView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomView.snp.top)
        }
    }
    
    func updateAdditionalViewsForKeyboard(notification: NSNotification, keyboardHeight: CGFloat) {}
    
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
        navibarContentStackView.addArrangedSubviews(leftNavigationButton, languageLabel, rightNavigationButton)
        bottomView.addSubviews(thinLine, randomSubjectButton)
        
        navigationView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(convertByHeightRatio(66))
        }
        
        navibarContentStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            if let strategy = diaryStrategy, strategy is ForeignDiaryStrategy || strategy is StepOneKoreanDiaryStrategy {
                $0.leading.equalToSuperview().offset(convertByWidthRatio(18))
            } else {
                $0.leading.equalToSuperview().offset(convertByWidthRatio(12))
            }
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
        
        bottomView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(convertByHeightRatio(87))
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
    
    private func checkTooltip() {
        let randomSubjectToolTipe = UserDefaultsManager.randomSubjectToolTip
        
        if !randomSubjectToolTipe {
            
            view.addSubview(randomSubjectToolTip ?? UIImageView())
            
            randomSubjectToolTip?.snp.makeConstraints {
                $0.width.equalTo(convertByWidthRatio(180))
                $0.height.equalTo(convertByHeightRatio(48))
                $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(constraintByNotch(-37, -42))
                $0.trailing.equalToSuperview().inset(convertByHeightRatio(18))
            }
        } else {
            randomSubjectToolTip = nil
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

// MARK: - Extensions

extension DiaryViewController {
    func showToastIfNeeded(toastType: ToastViewType) {
        smeemToastView?.removeFromSuperview()
        smeemToastView = SmeemToastView(type: toastType)
        
        let onKeyboardOffset = convertByHeightRatio(73)
        let offKeyboardOffset = convertByHeightRatio(107)
        
        // 키보드가 보이는지 확인하여 오프셋을 변경합니다.
        let offset = isKeyboardVisible ?  onKeyboardOffset : offKeyboardOffset
        
        smeemToastView?.show(in: view, offset: CGFloat(offset), keyboardHeight: keyboardHeight)
        smeemToastView?.hide(after: 1)
    }
}

// MARK: - UITextViewDelegate

extension DiaryViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let isTextEmpty = textView.text.isEmpty || textView.text == diaryStrategy?.textViewPlaceholder
        
        if isTextEmpty {
            textView.text = diaryStrategy?.textViewPlaceholder
            textView.textColor = .gray400
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        } else {
            textView.textColor = .smeemBlack
        }
        
        guard let strategy = diaryStrategy else {
            rightNavigationButton.setTitleColor(.gray300, for: .normal)
            return
        }
        
        if let koreanStrategy = strategy as? StepOneKoreanDiaryStrategy {
            if koreanStrategy.koreanValidation(with: textView.text, in: self) {
                rightButtonFlag = true
            } else {
                rightButtonFlag = false
            }
        } else {
            if strategy.englishValidation(with: textView.text, in: self) {
                rightButtonFlag = true
            } else {
                rightButtonFlag = false
            }
        }
        
        rightNavigationButton.setTitleColor(rightButtonFlag ? .point : .gray300, for: .normal)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if textView.textColor == .gray400 {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            textView.text = diaryStrategy?.textViewPlaceholder
            textView.textColor = .gray400
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            return false
        } else if textView.textColor == .gray400 && !text.isEmpty {
            textView.text = nil
            textView.textColor = .smeemBlack
        }
        return true
    }
}

extension DiaryStrategy {
    func englishValidation(with text: String, in viewController: DiaryViewController) -> Bool {
        return viewController.inputTextView.text.getArrayAfterRegex(regex: "[a-zA-z]").count > 0
    }
    
}

extension StepOneKoreanDiaryStrategy {
    func koreanValidation(with text: String, in viewController: DiaryViewController) -> Bool {
        return viewController.inputTextView.text.getArrayAfterRegex(regex: "[가-핳ㄱ-ㅎㅏ-ㅣ]").count > 0
    }
}

//MARK: - RandomSubjectViewDelegate

extension DiaryViewController: RandomSubjectViewDelegate {
    func refreshButtonTapped(completion: @escaping (String?) -> Void) {
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
            guard let postDiaryResponse = response?.data else { return }
            self.diaryID = postDiaryResponse.diaryID
            
            if !postDiaryResponse.badges.isEmpty {
                self.badgePopupContent = postDiaryResponse.badges
            } else {
                self.badgePopupContent = []
            }
            
            DispatchQueue.main.async {
                self.hideLodingView(loadingView: self.loadingView)
                let homeVC = HomeViewController()
                homeVC.toastMessageFlag = true
                homeVC.badgePopupData = self.badgePopupContent
                self.randomSubjectToolTip = nil
                let rootVC = UINavigationController(rootViewController: homeVC)
                self.changeRootViewControllerAndPresent(rootVC)
            }
        }
    }
}
