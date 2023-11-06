//
//  DiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/04.
//

import UIKit

class DiaryViewController: BaseViewController, NavigationBarActionDelegate {
    
    // MARK: - Properties
    
    private (set) var rootView: DiaryView?
    private (set) var viewModel: DiaryViewModel?
    
    private var keyboardHandler: KeyboardFollowingLayoutHandler?
    private var delegateSetupStrategy: DelegateSetupStrategy = DefaultDelegateSetupStrategy()
    
    // MARK: - Life Cycle
    
    init(rootView: DiaryView) {
        self.rootView = rootView
        self.viewModel = DiaryViewModel()
        super.init(nibName: nil, bundle: nil)
        
        setNagivationBarDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
        view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        showKeyboard(textView: diaryView.inputTextView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
        setupTextValidation()
        setupKeyboardHandler()
        setupUpdateRandomTopic()
        //        diaryView?.leftButtonActionStategy = DismissLeftButtonActionStrategy(viewContoller: self)
    }
    
    deinit {
        keyboardHandler = nil
    }
    
    func didTapLeftButton() { }
    func didTapRightButton() { }
}

// MARK: - Extensions

extension DiaryViewController {
    
    // MARK: - Get Methods
    
    func getTopicID() -> Int {
        return self.viewModel?.topicID ?? -1
    }
    
    func getInputText() -> String {
        return self.rootView?.inputTextView.text ?? ""
    }
    
    // MARK: - Settings
    
    private func setRootView() {
        view = rootView
    }
    
    private func setupDelegate() {
        delegateSetupStrategy.setupDelegate(for: self)
        setTextViewDelegate()
        setBottomViewDelegate()
        setRandomTopicRefreshDelegate()
    }
    
    func setNagivationBarDelegate() {
        rootView?.setNavigationBarDelegate(self)
    }
    
    func setTextViewDelegate() {
        rootView?.setTextViewHandlerDelegate(self)
    }
    
    private func setBottomViewDelegate() {
        rootView?.bottomView.actionDelegate = self
    }
    
    private func setDelegateSetupStrategy(_ strategy: DelegateSetupStrategy) {
        delegateSetupStrategy = strategy
    }
    
    private func setRandomTopicRefreshDelegate() {
        rootView?.randomTopicView?.randomTopicRefreshDelegate = self
    }
    
    private func setupUpdateRandomTopic() {
        viewModel?.onUpdateRandomTopic = { [ weak self] isEnabled in
            self?.updateViewWithRandomTopicEnabled(isEnabled)
        }
    }
    
    // MARK: Setups
    
    private func setupTextValidation() {
        viewModel?.onUpdateTextValidation = { [ weak self] isValid in
            self?.rootView?.navigationView.updateRightButton(isValid: isValid)
        }
    }
    
    private func setupKeyboardHandler() {
        guard let rootView = rootView else { return }
        keyboardHandler = KeyboardFollowingLayoutHandler(targetView: rootView.inputTextView, bottomView: rootView.bottomView)
    }
    
    private func updateViewWithRandomTopicEnabled(_ isEnabled: Bool) {
        rootView?.randomTopicEnabled = isEnabled
        rootView?.updateRandomTopicView()
        rootView?.updateInputTextViewConstraints()
    }
    
    // MARK: - @objc
    
    //    @objc func dismissButtonDidTap() {
    //        dismissButton?.removeFromSuperview()
    //    }
    //
    //    @objc func randomSubjectToolTipDidTap() {
    //        self.randomSubjectToolTip?.isHidden = true
    //        UserDefaultsManager.randomSubjectToolTip = true
    //    }
    
    // MARK: - Custom Methods
    
    private func handleRandomTopicButtonTap() {
        guard let isEnabled = viewModel?.randomTopicEnabled else { return }
        if isEnabled {
            randomSubjectWithAPI()
            updateViewWithRandomTopicEnabled(isEnabled)
            rootView?.bottomView.randomTopicButton.setImage(Constant.Image.btnRandomSubjectActive, for: .normal)
        } else {
            rootView?.bottomView.randomTopicButton.setImage(Constant.Image.btnRandomSubjectInactive, for: .normal)
            viewModel?.isTopicCalled = false
            viewModel?.topicID = nil
        }
        rootView?.randomTopicView?.setData(contentText: viewModel?.topicContent ?? "")
    }
}

// MARK: - RandomSubjectViewDelegate

extension DiaryViewController: randomTopicRefreshDelegate {
    func refreshButtonTapped(completion: @escaping (String?) -> Void) {
        randomSubjectWithAPI()
    }
}

extension DiaryViewController: SmeemTextViewHandlerDelegate {
    func textViewDidChange(text: String, viewType: DiaryViewType) {
        var isValid: Bool
        
        switch viewType {
        case .foregin, .stepTwoKorean, .edit:
            isValid = SmeemTextViewHandler.shared.containsEnglishCharacters(with: text)
        case .stepOneKorean:
            isValid = SmeemTextViewHandler.shared.containsKoreanCharacters(with: text)
        }
        viewModel?.updateTextValidation(isValid)
    }
}

// MARK: - BottomViewActionDelegate

extension DiaryViewController: BottomViewActionDelegate {
    func didTapRandomTopicButton() {
        //        if !UserDefaultsManager.randomSubjectToolTip {
        //            UserDefaultsManager.randomSubjectToolTip = true
        //            randomSubjectToolTip?.isHidden = true
        //        }
        
        viewModel?.toggleRandomTopic()
        handleRandomTopicButtonTap()
    }
    
    func didTapHintButton() {
        //        isHintShowed.toggle()
        //        if isHintShowed {
        //            postPapagoApi(diaryText: hintTextView.text)
        //            hintButton.setImage(Constant.Image.btnTranslateActive, for: .normal)
        //        } else {
        //            hintTextView.text = hintText
        //            hintButton.setImage(Constant.Image.btnTranslateInactive, for: .normal)
        //        }
    }
}

// MARK: - Network

extension DiaryViewController {
    func randomSubjectWithAPI() {
        RandomSubjectAPI.shared.getRandomSubject { [weak self] response in
            guard let randomSubjectData = response?.data else { return }
            self?.viewModel?.topicID = randomSubjectData.topicId
            self?.viewModel?.topicContent = randomSubjectData.content
            self?.rootView?.randomTopicView?.setData(contentText: self?.viewModel?.topicContent ?? "")
        }
    }
    
    //    func postDiaryAPI() {
    //        PostDiaryAPI.shared.postDiary(param: PostDiaryRequest(content: diaryView.inputTextView.text, topicId: topicID)) { response in
    //            guard let postDiaryResponse = response?.data else { return }
    //            self.diaryID = postDiaryResponse.diaryID
    //
    //            if !postDiaryResponse.badges.isEmpty {
    //                self.badgePopupContent = postDiaryResponse.badges
    //            } else {
    //                self.badgePopupContent = []
    //            }
    //
    //            DispatchQueue.main.async {
    //                let homeVC = HomeViewController()
    //                homeVC.toastMessageFlag = true
    //                homeVC.badgePopupData = self.badgePopupContent
    //                //                self.randomSubjectToolTip = nil
    //                let rootVC = UINavigationController(rootViewController: homeVC)
    //                self.changeRootViewControllerAndPresent(rootVC)
    //            }
    //        }
    //    }
}


// MARK: - ToastView

//    func showToastIfNeeded(toastType: ToastViewType) {
//        smeemToastView?.removeFromSuperview()
//        smeemToastView = SmeemToastView(type: toastType)
//
//        let onKeyboardOffset = convertByHeightRatio(73)
//        let offKeyboardOffset = convertByHeightRatio(107)
//
//        let offset = isKeyboardVisible ? onKeyboardOffset : offKeyboardOffset
//
//        smeemToastView?.show(in: view, offset: CGFloat(offset), keyboardHeight: keyboardHeight)
//        smeemToastView?.hide(after: 1)
//    }


// MARK: - Tutorial

//extension DiaryViewController {
//    private func checkTutorial() {
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
//    }
//}
