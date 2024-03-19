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
//    private (set) var viewModel: DiaryViewModel
    
    private var keyboardHandler: KeyboardLayoutAndScrollingHandler?
    
    private var cancelBag = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(rootView: DiaryView) {
        self.rootView = rootView
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
        rootView.toolTipDelegate = self
    }
    
    private func setupSubscriptions() {
//        bindTextValidationStatus()
//        bindToastVisibility()
    }
    
    // MARK: - Setups
    
    private func bindTextValidationStatus() {
        viewModel.onUpdateTextValidation.bind(listener: { [weak self] isValid in
            self?.rootView.navigationView.updateRightButton(isValid: isValid)
        })
    }
    
//    private func bindToastVisibility() {
//        viewModel.toastType.bind(listener: { [weak self] toastType in
//            if let toastType {
//                self?.rootView.showToast(with: toastType)
//            }
//        })
//    }
    
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

// MARK: - SmeemTextViewHandlerDelegate

extension DiaryViewController: SmeemTextViewHandlerDelegate {
    func textViewDidChange(text: String, viewType: DiaryViewType) {
        print("textViewDidChange")
//        let isValid = viewModel.isTextValid(text: text, viewType: viewType)
//        viewModel.updateTextValidation(isValid)
//        viewModel.inputText.value = text
    }
    
    func onUpdateInputText(_ text: String) {
        print("onUpdateInputText")
//        viewModel.onUpdateInputText?(text)
    }
    
    func onUpdateTopicID(_ id: String) {
        print("onUpdateTopicID")
//        viewModel.onUpdateTopicID?(id)
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
//        viewModel.callRandomTopicAPI()
//        self.rootView.randomTopicView.updateText(with: viewModel.model.topicContent ?? "")
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
        print("handleError")
//        viewModel.onError = { [weak self] error in
//            guard let error = error as? SmeemError else { return }
//            
//            self?.rootView.showToast(with: .smeemErrorToast(message: error))
//        }
    }
}
