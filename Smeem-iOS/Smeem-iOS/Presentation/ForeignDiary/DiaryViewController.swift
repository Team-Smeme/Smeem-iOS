//
//  DiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/04.
//

import UIKit

class DiaryViewController: BaseViewController {
    
    // MARK: - Properties
    
    private (set) var rootView: DiaryView?
    private (set) var viewModel: DiaryViewModel?
    
    private var keyboardHandler: KeyboardFollowingLayoutHandler?
    private var navigationBarButtonActionStrategy: any NavigationActionStrategy = DefaultNavigationActionStrategy()
    private var delegateSetupStrategy: DefaultDelegateSetupStrategy?
    
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
        showKeyboard(textView: rootView?.inputTextView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegates()
        setupTextValidation()
        setupKeyboardHandler()
        setupUpdateRandomTopic()
    }
    
    deinit {
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
        //        delegateSetupStrategy.setupDelegate(for: self)
        setTextViewDelegate()
        setBottomViewDelegate()
        setRandomTopicRefreshDelegate()
    }
    
    func setNagivationBarDelegate() {
        rootView?.setNavigationBarDelegate(self)
    }
    
    private func setTextViewDelegate() {
        rootView?.setTextViewHandlerDelegate(self)
    }
    
    private func setBottomViewDelegate() {
        rootView?.bottomView.randomTopicDelegate = self
    }
    
    private func setDelegateSetupStrategy(_ strategy: DelegateSetupStrategy) {
        delegateSetupStrategy = strategy as? DefaultDelegateSetupStrategy ?? nil
    }
    
    func setNavigationBarButtonActionStrategy(_ strategy: any NavigationActionStrategy) {
        navigationBarButtonActionStrategy = strategy
    }
    
    private func setRandomTopicRefreshDelegate() {
        rootView?.randomTopicView?.randomTopicRefreshDelegate = self
    }
    
    // MARK: - Setups
    
    private func setupTextValidation() {
        viewModel?.onUpdateTextValidation = { [ weak self] isValid in
            self?.rootView?.navigationView.updateRightButton(isValid: isValid)
        }
    }
    
    private func setupKeyboardHandler() {
        guard let rootView = rootView else { return }
        keyboardHandler = KeyboardFollowingLayoutHandler(targetView: rootView.inputTextView, bottomView: rootView.bottomView)
    }
    
    private func setupUpdateRandomTopic() {
        viewModel?.onUpdateRandomTopic = { [ weak self] isEnabled in
            self?.updateViewWithRandomTopicEnabled(isEnabled)
        }
        
        viewModel?.onUpdateTopicContent = { [ weak self] content in
            self?.rootView?.randomTopicView?.setData(contentText: content)
        }
    }
    
    // MARK: - Custom Methods
    
    private func handleRandomTopicButtonTap() {
        guard let isEnabled = viewModel?.randomTopicEnabled else { return }
        
        rootView?.bottomView.updateRandomTopicButtonImage(isEnabled)
        
        if isEnabled {
            viewModel?.randomSubjectWithAPI()
            updateViewWithRandomTopicEnabled(isEnabled)
        } else {
            viewModel?.isTopicCalled = false
            viewModel?.topicID = nil
        }
        rootView?.randomTopicView?.setData(contentText: viewModel?.topicContent ?? "")
    }
    
    private func updateViewWithRandomTopicEnabled(_ isEnabled: Bool) {
        rootView?.updateRandomTopicView(isRandomTopicActive: isEnabled)
        rootView?.updateInputTextViewConstraints(isRandomTopicActive: isEnabled)
    }
    
    // MARK: - Network
    
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

// MARK: - NavigationBarActionDelegate

extension DiaryViewController: NavigationBarActionDelegate {
    func didTapLeftButton() {
        navigationBarButtonActionStrategy.performLeftButtonAction()
    }
    
    func didTapRightButton() {
        navigationBarButtonActionStrategy.performRightButtonAction()
    }
}

// MARK: - RandomSubjectViewDelegate

extension DiaryViewController: RandomTopicRefreshDelegate {
    func refreshButtonTapped(completion: @escaping (String?) -> Void) {
        viewModel?.randomSubjectWithAPI()
    }
}

// MARK: - SmeemTextViewHandlerDelegate

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
