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
    
    // MARK: - Subjects
    
    private (set) var amplitudeSubject = PassthroughSubject<Void, Never>()
    
    private var cancelBag = Set<AnyCancellable>()
    
    // MARK: - Properties
    
    private (set) var rootView: DiaryView
    private (set) var viewModel: ViewModelType
    
    private var keyboardHandler: KeyboardLayoutAndScrollingHandler?
    
    // MARK: - Life Cycle
    
    init(rootView: DiaryView, viewModel: ViewModelType) {
        self.rootView = rootView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
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
        
        output.textValidationResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                
                self?.rootView.navigationView.updateRightButton(isValid: isValid)
            }
            .store(in: &cancelBag)
        
        output.errorResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showToast(toastType: .smeemErrorToast(message: error))
            }
            .store(in: &cancelBag)
    }
    
    // MARK: - Settings
    
    private func setupDelegates() {
        rootView.toolTipDelegate = self
    }
    
    private func setupKeyboardHandler() {
        keyboardHandler = KeyboardLayoutAndScrollingHandler(targetView: rootView.inputTextView, bottomView: rootView.bottomView)
    }
}

// MARK: - Action Helpers

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
