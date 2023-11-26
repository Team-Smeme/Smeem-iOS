//
//  DiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/04.
//

import UIKit

class DiaryViewController: BaseViewController {
    
    // MARK: Properties
    private (set) var rootView: DiaryView?
    private (set) var viewModel: DiaryViewModel?
    
    private var keyboardHandler: KeyboardLayoutAndScrollingHandler?
    
    // MARK: - Life Cycle
    
    init(rootView: DiaryView, viewModel: DiaryViewModel) {
        self.rootView = rootView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        setupSubscriptions()
        setupDelegates()
        setupKeyboardHandler()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
        view = rootView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showKeyboard(textView: rootView?.inputTextView)
    }
    
    deinit {
        removeListeners()
        keyboardHandler = nil
    }
}

// MARK: - Extensions

extension DiaryViewController {
    
    // MARK: - Settings
    
    private func setRootView() {
        view = rootView
    }
    
    private func setupDelegates() {
        setTextViewDelegate()
        setBottomViewDelegate()
        setRandomTopicRefreshDelegate()
    }
    
    private func setupSubscriptions() {
        setupTextValidationSubscription()
        setupUpdateRandomTopicSubscription()
    }
    
    private func setTextViewDelegate() {
        rootView?.setTextViewHandlerDelegate(self)
    }
    
    private func setBottomViewDelegate() {
        rootView?.bottomView.randomTopicDelegate = self
    }
    
    private func setRandomTopicRefreshDelegate() {
        rootView?.randomTopicView.randomTopicRefreshDelegate = self
    }
    
    private func removeListeners() {
        viewModel?.isTextValid.listener = nil
        viewModel?.onUpdateRandomTopic.listener = nil
    }
    
    // MARK: - Setups
    
    private func setupTextValidationSubscription() {
        viewModel?.isTextValid.subscribe(listener: { [weak self] isValid in
            self?.rootView?.navigationView.updateRightButton(isValid: isValid)
        })
    }
    
    private func setupUpdateRandomTopicSubscription() {
        viewModel?.onUpdateRandomTopic.subscribe(listener: { [weak self] isEnabled in
            self?.updateViewWithRandomTopicEnabled(isEnabled)
        })
        
        viewModel?.onUpdateTopicContent.subscribe(listener: { [weak self] content in
            self?.rootView?.randomTopicView.setData(contentText: content)
        })
    }
    
    private func setupKeyboardHandler() {
        guard let rootView = rootView else { return }
        keyboardHandler = KeyboardLayoutAndScrollingHandler(targetView: rootView.inputTextView, bottomView: rootView.bottomView)
    }
    
    // MARK: - Custom Methods
    
    private func handleRandomTopicButtonTap() {
        guard let isEnabled = viewModel?.isRandomTopicActive.value else { return }
        
        rootView?.bottomView.updateRandomTopicButtonImage(isEnabled)
        
        if isEnabled {
            viewModel?.randomSubjectWithAPI()
            updateViewWithRandomTopicEnabled(isEnabled)
        } else {
            viewModel?.isTopicCalled = false
            viewModel?.topicID = nil
        }
        rootView?.randomTopicView.setData(contentText: viewModel?.topicContent ?? "")
    }
    
    private func updateViewWithRandomTopicEnabled(_ isActive: Bool) {
        viewModel?.isRandomTopicActive.subscribe(listener: { [weak self] isActive in
            self?.rootView?.updateRandomTopicView(isRandomTopicActive: isActive)
            self?.rootView?.updateInputTextViewConstraints(isRandomTopicActive: isActive)
        })
    }
}

// MARK: - RandomTopicRefreshDelegate

extension DiaryViewController: RandomTopicRefreshDelegate {
    func refreshButtonTapped(completion: @escaping (String?) -> Void) {
        viewModel?.randomSubjectWithAPI()
    }
}

// MARK: - SmeemTextViewHandlerDelegate

extension DiaryViewController: SmeemTextViewHandlerDelegate {
    func textViewDidChange(text: String, viewType: DiaryViewType) {
        let isValid = viewModel?.isTextValid(text: text, viewType: viewType)
        viewModel?.updateTextValidation(isValid ?? false)
        viewModel?.inputText.value = text
    }
    
    func onUpdateInputText(_ text: String) {
        viewModel?.onUpdateInputText?(text)
    }
    
    func onUpdateTopicID(_ id: String) {
        viewModel?.onUpdateTopicID?(id)
    }
}

// MARK: - BottomViewActionDelegate

extension DiaryViewController: RandomTopicActionDelegate {
    func didTapRandomTopicButton() {
        // TODO: - Tutorial
        //        if !UserDefaultsManager.randomSubjectToolTip {
        //            UserDefaultsManager.randomSubjectToolTip = true
        //            randomSubjectToolTip?.isHidden = true
        //        }
        
        viewModel?.toggleRandomTopic()
        handleRandomTopicButtonTap()
    }
}

// MARK: - Network

extension DiaryViewController {
    func handlePostDiaryResponse(_ response: PostDiaryResponse?) {
        DispatchQueue.main.async {
            let homeVC = HomeViewController()
            homeVC.toastMessageFlag = true
            homeVC.badgePopupData = response?.badges ?? []
            
            let rootVC = UINavigationController(rootViewController: homeVC)
            homeVC.changeRootViewControllerAndPresent(rootVC)
        }
    }
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

//    @objc func dismissButtonDidTap() {
//        dismissButton?.removeFromSuperview()
//    }
//
//    @objc func randomSubjectToolTipDidTap() {
//        self.randomSubjectToolTip?.isHidden = true
//        UserDefaultsManager.randomSubjectToolTip = true
//    }

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
