//
//  DiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/04.
//

import UIKit

import SnapKit

protocol DiaryStrategy {
    
}

class DiaryViewController: UIViewController {
    
    // MARK: - Property
    
    var diaryStrategy: DiaryStrategy?
    
    private weak var delegate: UITextViewDelegate?
    
    private var randomTopicEnabled: Bool = false {
        didSet {
            //            updateRandomTopicView()
            //            updateInputTextViewConstraints()
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
    
    let navigationView = SmeemNavigationBar()
    
    let inputTextView = SmeemTextView(type: .editable(SmeemTextViewManager.shared), placeholderText: "일기를 작성해주세요 :)")
    
    let bottomView = DiaryBottomView(viewType: .withHint)
    
    private lazy var randomSubjectView = RandomSubjectView()
    var smeemToastView: SmeemToastView?
    let loadingView = LoadingView()
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardAddObserver()
        showKeyboard(textView: inputTextView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDiaryStrategy()
        setupUI()
        setDelegate()
//        checkTutorial()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        keyboardRemoveObserver()
        
        if let currentChildViewController = children.first {
            switch currentChildViewController {
            case is DiaryViewController:
                print("DiaryViewController")
            case is ForeignDiaryViewController:
                //                randomSubjectToolTip?.removeFromSuperview()
                print("ForeignDiaryViewController")
            case is StepOneKoreanDiaryViewController:
                print("StepOneKoreanDiaryViewController")
            case is StepTwoKoreanDiaryViewController:
                print("StepTwoKoreanDiaryViewController")
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
    
    //    @objc func randomTopicButtonDidTap() {
    //        if !UserDefaultsManager.randomSubjectToolTip {
    //            UserDefaultsManager.randomSubjectToolTip = true
    //            randomSubjectToolTip?.isHidden = true
    //        }
    //
    //        setRandomTopicButtonToggle()
    //
    //        if !isTopicCalled {
    //            randomSubjectWithAPI()
    //            randomSubjectButton.setImage(Constant.Image.btnRandomSubjectActive, for: .normal)
    //            isTopicCalled = true
    //        } else {
    //            isTopicCalled = false
    //            topicID = nil
    //        }
    //        randomSubjectView.setData(contentText: topicContent)
    //    }
    //
    //    @objc func leftNavigationButtonDidTap() {
    //        self.navigationController?.popViewController(animated: true)
    //    }
    
    //    @objc func rightNavigationButtonDidTap() {
    //        if !rightNavigationButton.isEnabled {
    //            showToastIfNeeded(toastType: .defaultToast(bodyType: .regEx))
    //        }
    //    }
    
    //    @objc func keyboardWillShow(notification: NSNotification) {
    //        guard let userInfo = notification.userInfo,
    //              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
    //        else { return }
    //
    //        let keyboardHeight = keyboardFrame.height
    //        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
    //        inputTextView.contentInset = insets
    //        inputTextView.scrollIndicatorInsets = insets
    //        self.bottomView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
    //
    //        self.keyboardHeight = keyboardFrame.height
    //        isKeyboardVisible = true
    //
    //        UIView.animate(withDuration: 0.3) {
    //            self.bottomView.snp.updateConstraints {
    //                $0.height.equalTo(53)
    //            }
    //            self.view.layoutIfNeeded()
    //        }
    //
    //        updateAdditionalViewsForKeyboard(notification: notification, keyboardHeight: keyboardHeight)
    //
    //    }
    //
    //    @objc func keyboardWillHide(notification: NSNotification) {
    //        inputTextView.contentInset = .zero
    //        inputTextView.scrollIndicatorInsets = .zero
    //        self.bottomView.transform = CGAffineTransform.identity
    //
    //        isKeyboardVisible = false
    //
    //        UIView.animate(withDuration: 0.3) {
    //            self.bottomView.snp.updateConstraints {
    //                $0.height.equalTo(87)
    //            }
    //            self.view.layoutIfNeeded()
    //        }
    //
    //        updateAdditionalViewsForKeyboard(notification: notification, keyboardHeight: 0)
    //    }
    //
    //    @objc func dismissButtonDidTap() {
    //        dismissButton?.removeFromSuperview()
    //    }
    //
    //    @objc func randomSubjectToolTipDidTap() {
    //        self.randomSubjectToolTip?.isHidden = true
    //        UserDefaultsManager.randomSubjectToolTip = true
    //    }
    
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
    
    private func setBackgroundColor() {
        view.backgroundColor = .smeemWhite
    }
    
    private func setRandomTopicButtonToggle() {
        randomTopicEnabled.toggle()
    }
    
    //    private func updateRandomTopicView() {
    //        if randomTopicEnabled {
    //            view.addSubview(randomSubjectView)
    //            randomSubjectView.snp.makeConstraints {
    //                $0.top.equalTo(navigationView.snp.bottom).offset(convertByHeightRatio(16))
    //                $0.leading.equalToSuperview()
    //            }
    //            randomSubjectButton.setImage(Constant.Image.btnRandomSubjectActive, for: .normal)
    //        } else {
    //            randomSubjectView.removeFromSuperview()
    //            randomSubjectButton.setImage(Constant.Image.btnRandomSubjectInactive, for: .normal)
    //        }
    //    }
    //
    //    private func updateInputTextViewConstraints() {
    //        inputTextView.snp.remakeConstraints {
    //            $0.top.equalTo(randomTopicEnabled ? randomSubjectView.snp.bottom : navigationView.snp.bottom)
    //            $0.leading.trailing.equalToSuperview()
    //            $0.bottom.equalTo(bottomView.snp.top)
    //        }
    //    }
    
    func updateAdditionalViewsForKeyboard(notification: NSNotification, keyboardHeight: CGFloat) {}
    
    private func keyboardAddObserver() {
        //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func keyboardRemoveObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Layout
    
    private func setLayout() {
        view.addSubviews(navigationView, inputTextView, bottomView)
        
        navigationView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(convertByHeightRatio(66))
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
        let offset = isKeyboardVisible ? onKeyboardOffset : offKeyboardOffset
        
        smeemToastView?.show(in: view, offset: CGFloat(offset), keyboardHeight: keyboardHeight)
        smeemToastView?.hide(after: 1)
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
                //                self.randomSubjectToolTip = nil
                let rootVC = UINavigationController(rootViewController: homeVC)
                self.changeRootViewControllerAndPresent(rootVC)
            }
        }
    }
}
