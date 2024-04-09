//
//  DiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/04.
//

import UIKit
import Combine

// MARK: - DiaryViewController

class DiaryViewController<ViewModelType: DiaryViewModel>: BaseViewController {
    
    // MARK: - Properties
    
    private (set) var rootView: DiaryView
    private (set) var viewModel: ViewModelType
    
    private var keyboardHandler: KeyboardLayoutAndScrollingHandler?
    
    private (set) var amplitudeSubject = PassthroughSubject<Void, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(rootView: DiaryView, viewModel: ViewModelType) {
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
        
        handleError()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showKeyboard(textView: rootView.inputTextView)
        amplitudeSubject.send()
    }
    
    deinit {
        keyboardHandler = nil
    }
}

// MARK: - Extensions

extension DiaryViewController {
    
    private func bind() {
        // TODO: 강제 언래핑?
        let input = DiaryViewModel.Input(textDidChangeSubject: rootView.inputTextView.textViewHandler!.textDidChangeSubject,
                                         viewTypeSubject: rootView.viewTypeSubject)
        let output = viewModel.transform(input: input)
        
        output.textValidationAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                self?.rootView.navigationView.updateRightButton(isValid: isValid)
            }
            .store(in: &cancelBag)
    }
    
    // MARK: - Settings
    
    private func setupDelegates() {
        rootView.toolTipDelegate = self
    }
    
    private func setupSubscriptions() {
        //        bindToastVisibility()
    }
    
    // MARK: - Setups
    
    //    private func bindToastVisibility() {
    //        viewModel.toastType.bind(listener: { [weak self] toastType in
    //            if let toastType {
    //                self?.rootView.showToast(with: toastType)
    //            }
    //        })
    //    }
    
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

// MARK: - ToolTipDelegate

extension DiaryViewController: ToolTipDelegate {
    func didTapToolTipButton() {
        rootView.removeToolTip()
        UserDefaultsManager.randomTopicToolTip = true
    }
}

// MARK: - Network

extension DiaryViewController {
    func handlePostDiaryResponse(_ response: PostDiaryResponse?) {
        DispatchQueue.main.async {
            let homeVC = HomeViewController()
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
