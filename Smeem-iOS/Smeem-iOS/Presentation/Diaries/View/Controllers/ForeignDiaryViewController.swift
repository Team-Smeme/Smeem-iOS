//
//  ForeignDiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/05.
//

import UIKit
import Combine

// MARK: - ForeignDiaryViewController

final class ForeignDiaryViewController: DiaryViewController<ForeignDiaryViewModel> {
    
    // MARK: - Subjects
    
    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    
    private var cancelBag = Set<AnyCancellable>()
    
    // MARK: - Properties
    
    private let viewFactory = DiaryViewFactory()
    
    // MARK: - Life Cycle
    
    init(viewModel:ForeignDiaryViewModel) {
        super.init(rootView: viewFactory.createForeginDiaryView(), viewModel:viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        viewDidLoadSubject.send()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideKeyboard()
    }
}

// MARK: - Extensions

extension ForeignDiaryViewController {
    private func bind() {
        let input = ForeignDiaryViewModel.Input(viewDidLoadSubject: viewDidLoadSubject,
                                                rightButtonTapped: rootView.navigationView.rightButtonTapped,
                                                randomTopicButtonTapped: rootView.bottomView.randomTopicButtonTapped,
                                                refreshButtonTapped: rootView.randomTopicView.refreshButtonTapped, 
                                                toolTipTapped: rootView.toolTipTapped)
        
        let output = viewModel.transform(input: input)
        
        rootView.navigationView.leftButtonTapped
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.rootView.removeToolTip()
                self?.presentingViewController?.dismiss(animated: true)
            }
            .store(in: &cancelBag)
        
        output.rightButtonAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                self?.rootView.inputTextView.resignFirstResponder()
                
                let homeVC = HomeViewController()
                let rootVC = UINavigationController(rootViewController: homeVC)
                homeVC.handlePostDiaryAPI(with: response)
                homeVC.changeRootViewControllerAndPresent(rootVC)
            }
            .store(in: &cancelBag)
        
        output.randomTopicButtonAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let isActive = self?.viewModel.isRandomTopicActive.value,
                      let content = self?.viewModel.topicContentSubject.value else { return }
                
                self?.rootView.bottomView.updateRandomTopicButtonImage(isActive)
                self?.rootView.updateRandomTopicView(isRandomTopicActive: isActive)
                self?.rootView.updateInputTextViewConstraints(isRandomTopicActive: isActive)
                self?.rootView.randomTopicView.updateText(with: content)
            }
            .store(in: &cancelBag)
        
        output.refreshButtonAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let content = self?.viewModel.topicContentSubject.value else { return }
                
                self?.rootView.randomTopicView.updateText(with: content)
            }
            .store(in: &cancelBag)
        
        output.toolTipAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.rootView.removeToolTip()
            }
            .store(in: &cancelBag)
        
        output.toolTipResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.rootView.setToolTip()
            }
            .store(in: &cancelBag)
        
        output.toastValidationResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] height in
                self?.showToast(toastType: .smeemToast(bodyType: .regEx), hasKeyboard: true, height: height)
            }
            .store(in: &cancelBag)
    }
}
