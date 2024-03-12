//
//  DiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/04.
//

import UIKit
import Combine

// MARK: - DiaryViewController

class DiaryViewController: BaseViewController {
    
    // MARK: - Properties
    
    private (set) var rootView: DiaryView
    private (set) var viewModel: DiaryViewModel
    
    private var keyboardHandler: KeyboardLayoutAndScrollingHandler?
    
    private var cancelBag = Set<AnyCancellable>()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        handleError()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showKeyboard(textView: rootView.inputTextView)
    }
    
    deinit {
        keyboardHandler = nil
    }
}

// MARK: - Extensions

extension DiaryViewController {
    
    // MARK: - Settings
    
    private func setupDelegates() {
        rootView.setTextViewHandlerDelegate(self)
        rootView.randomTopicView?.randomTopicRefreshDelegate = self
        rootView.toolTipDelegate = self
    }
    
    private func setupSubscriptions() {
        bindTextValidationStatus()
        bindRandomTopicUpdates()
        bindToastVisibility()
    }
    
    private func removeListeners() {
        viewModel.onUpdateTextValidation.listener = nil
    }
    
    // MARK: - Setups
    
    private func bind() {
        let input = DiaryViewModel.Input(randomTopicButtonTapped: rootView.bottomView.randomTopicButtonTapped,
                                         hintButtonTapped: rootView.bottomView.hintButtonTapped)
        
        let output = viewModel.transform(input: input)
        
        output.randomTopicButtonAction
            .sink { _ in
                self.checkGuidToolTip()
                
                var isActive = self.viewModel.isRandomTopicActive.value
                
                DispatchQueue.main.async {
                    self.rootView.bottomView.updateRandomTopicButtonImage(isActive)
                    self.rootView.updateRandomTopicView(isRandomTopicActive: isActive)
                    self.rootView.updateInputTextViewConstraints(isRandomTopicActive: isActive)
                }
            }
            .store(in: &cancelBag)
        
        output.hintButtonAction
            .sink { _ in
                DispatchQueue.main.async {
                    
                }
            }
            .store(in: &cancelBag)
    }
    
    private func bindTextValidationStatus() {
        viewModel.onUpdateTextValidation.bind(listener: { [weak self] isValid in
            self?.rootView.navigationView.updateRightButton(isValid: isValid)
        })
    }
    
    private func bindRandomTopicUpdates() {
        viewModel.onUpdateTopicContent.bind(listener: { [weak self] content in
            self?.rootView.randomTopicView?.setData(contentText: content)
        })
    }
    
    private func bindToastVisibility() {
        viewModel.toastType.bind(listener: { [weak self] toastType in
            if let toastType {
                self?.rootView.showToast(with: toastType)
            }
        })
    }
    
//        private func bindTopicID() {
//            viewModel?.onUpdateTopicID.bind(listener: { [weak self] id in
//                self?.viewModel?.onUpdateTopicID(id)
//            })
//        }
    
    private func setupKeyboardHandler() {
        keyboardHandler = KeyboardLayoutAndScrollingHandler(targetView: rootView.inputTextView, bottomView: rootView.bottomView)
    }
}

// MARK: - ActionHelpers

extension DiaryViewController {
    func checkGuidToolTip() {
        if !UserDefaultsManager.randomTopicToolTip {
            UserDefaultsManager.randomTopicToolTip = true
            rootView.removeToolTip()
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
        viewModel.updateTextValidation(isValid ?? false)
        viewModel.inputText.value = text
    }
    
    func onUpdateInputText(_ text: String) {
        viewModel.onUpdateInputText?(text)
    }
    
    func onUpdateTopicID(_ id: String) {
        viewModel.onUpdateTopicID?(id)
    }
}

// MARK: - ToolTipDelegate

extension DiaryViewController: ToolTipDelegate {
    func didTapToolTipButton() {
        rootView.removeToolTip()
        UserDefaultsManager.randomTopicToolTip = true
    }
}

// MARK: - Network

extension DiaryViewController {
    func handleInitialRandomTopicApiCall() {
        viewModel.callRandomTopicAPI()
        self.rootView.randomTopicView?.setData(contentText: viewModel.model.topicContent ?? "")
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
            
            self?.rootView.showToast(with: .smeemErrorToast(message: error))
        }
    }
}
