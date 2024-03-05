//
//  DiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/04.
//

import Combine
import UIKit

// MARK: - DiaryViewController

class DiaryViewController: BaseViewController {
    
    // MARK: - Properties
    
    private (set) var rootView: DiaryView?
    private (set) var viewModel: DiaryViewModel
    private var keyboardHandler: KeyboardLayoutAndScrollingHandler?
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(rootView: DiaryView, viewModel: DiaryViewModel) {
        self.rootView = rootView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        subscribeToViewPublishers()
        setupDelegates()
        setupKeyboardHandler()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handleError()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showKeyboard(textView: rootView?.inputTextView)
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
        keyboardHandler = nil
    }
}

// MARK: - Extensions

extension DiaryViewController {
    
    // MARK: - Settings
    
    private func setupDelegates() {
        rootView?.setTextViewHandlerDelegate(self)
        rootView?.bottomView.randomTopicDelegate = self
        rootView?.randomTopicView?.randomTopicRefreshDelegate = self
        rootView?.toolTipDelegate = self
    }
    
    // MARK: - Setups
    
    private func subscribeToViewPublishers() {
        rootView?.leftButtonPublisher
            .sink { [weak self] _ in
                self?.viewModel.leftButtonTapped()
            }
            .store(in: &cancellables)

        rootView?.rightButtonPublisher
            .sink { [weak self] _ in
                self?.viewModel.rightButtonTapped()
            }
            .store(in: &cancellables)
    }
    
//    private func bindTextValidationStatus() {
//        viewModel.onUpdateTextValidation.bind(listener: { [weak self] isValid in
//            self?.rootView?.navigationView.updateRightButton(isValid: isValid)
//        })
//    }
//    
//    private func bindRandomTopicUpdates() {
//        viewModel.onUpdateTopicContent.bind(listener: { [weak self] content in
//            self?.rootView?.randomTopicView?.setData(contentText: content)
//        })
//        
//        viewModel.onUpdateRandomTopic.bind(listener: { [weak self] isEnabled in
//            self?.updateViewWithRandomTopicActive()
//        })
//    }
//    
//    private func bindToastVisibility() {
//        viewModel.toastType.bind(listener: { [weak self] toastType in
//            if let toastType {
//                self?.rootView?.showToast(with: toastType)
//            }
//        })
//    }
//    
//    private func bindRandomTopicActive() {
//        viewModel.isRandomTopicActive.bind(listener: { [weak self] isActive in
//            self?.rootView?.updateRandomTopicView(isRandomTopicActive: isActive)
//            self?.rootView?.updateInputTextViewConstraints(isRandomTopicActive: isActive)
//        })
//    }
    
    private func setupKeyboardHandler() {
        guard let rootView = rootView else { return }
        keyboardHandler = KeyboardLayoutAndScrollingHandler(targetView: rootView.inputTextView, bottomView: rootView.bottomView)
    }
    
    // MARK: - Custom Methods
    
    private func handleRandomTopicButtonTap() {
        let isActive = viewModel.isRandomTopicActive.value
        
        rootView?.bottomView.updateRandomTopicButtonImage(isActive)
        
        if isActive {
            if viewModel.model.topicContent?.isEmpty == nil {
                viewModel.callRandomTopicAPI()
            }
//            bindRandomTopicActive()
        } else {
            viewModel.updateModel(isTopicCalled: false, topicContent: nil)
        }
    }
}

// MARK: - RandomTopicRefreshDelegate

extension DiaryViewController: RandomTopicRefreshDelegate {
    func refreshButtonTapped(completion: @escaping (String?) -> Void) {
        viewModel.callRandomTopicAPI()
    }
}

// MARK: - SmeemTextViewHandlerDelegate

extension DiaryViewController: SmeemTextViewHandlerDelegate {
    func textViewDidChange(text: String, viewType: DiaryViewType) {
        let isValid = viewModel.isTextValid(text: text, viewType: viewType)
        viewModel.updateTextValidation(isValid)
        viewModel.inputText.value = text
    }
    
    func onUpdateInputText(_ text: String) {
        viewModel.onUpdateInputText?(text)
    }
    
    func onUpdateTopicID(_ id: String) {
        viewModel.onUpdateTopicID?(id)
    }
}

// MARK: - BottomViewActionDelegate

extension DiaryViewController: RandomTopicActionDelegate {
    func didTapRandomTopicButton() {
        if !UserDefaultsManager.randomSubjectToolTip {
            UserDefaultsManager.randomSubjectToolTip = true
            rootView?.removeToolTip()
        }
        
        viewModel.toggleRandomTopic()
        handleRandomTopicButtonTap()
    }
}

// MARK: - ToolTipDelegate

extension DiaryViewController: ToolTipDelegate {
    func didTapToolTipButton() {
        rootView?.removeToolTip()
        UserDefaultsManager.randomSubjectToolTip = true
    }
}

// MARK: - Network

extension DiaryViewController {
    func handleInitialRandomTopicApiCall() {
        viewModel.callRandomTopicAPI()
        self.rootView?.randomTopicView?.setData(contentText: viewModel.model.topicContent ?? "")
    }
    
    func handlePostDiaryResponse(_ response: PostDiaryResponse?) {
        DispatchQueue.main.async {
            let homeVC = HomeViewController()
            homeVC.toastMessageFlag = true
            homeVC.badgePopupData = response?.badges ?? []
            
            let rootVC = UINavigationController(rootViewController: homeVC)
            homeVC.changeRootViewControllerAndPresent(rootVC)
        }
    }
    
    func handleError() {
        viewModel.onError = { [weak self] error in
            guard let error = error as? SmeemError else { return }
            
            self?.rootView?.showToast(with: .smeemErrorToast(message: error))
        }
    }
}
