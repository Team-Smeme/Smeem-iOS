//
//  StepOneKoreanDiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/05.
//

import UIKit
import Combine

// MARK: - StepOneKoreanDiaryViewController

final class StepOneKoreanDiaryViewController: DiaryViewController<StepOneKoreanDiaryViewModel> {
    
    // MARK: - Subjects
    
    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    
    private var cancelBag = Set<AnyCancellable>()
    
    // MARK: - Properties
    
    private let viewFactory = DiaryViewFactory()
    
    // MARK: - Life Cycle
    
    init(viewModel: StepOneKoreanDiaryViewModel) {
        super.init(rootView: viewFactory.createStepOneKoreanDiaryView(), viewModel: viewModel)
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

// MARK: - Bind

extension StepOneKoreanDiaryViewController {
    private func bind() {
        let input = StepOneKoreanDiaryViewModel.Input(viewDidLoadSubject: viewDidLoadSubject,
                                                      leftButtonTapped: rootView.navigationView.leftButtonTapped,
                                                      rightButtonTapped: rootView.navigationView.rightButtonTapped,
                                                      randomTopicButtonTapped: rootView.bottomView.randomTopicButtonTapped,
                                                      refreshButtonTapped: rootView.randomTopicView.refreshButtonTapped,
                                                      toolTipTapped: rootView.toolTipTapped
        )
        
        let output = viewModel.transform(input: input)
        
        output.leftButtonAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.rootView.removeToolTip()
                self?.presentingViewController?.dismiss(animated: true)
            }
            .store(in: &cancelBag)
        
        output.rightButtonAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.rootView.inputTextView.resignFirstResponder()
                guard let diaryText = self?.rootView.inputTextView.text else { return }
                let diaryViewControllerFactory = DiaryViewControllerFactory(diaryViewFactory: DiaryViewFactory())
                let nextVC = diaryViewControllerFactory.makeStepTwoKoreanDiaryViewController(with: diaryText)
                self?.navigationController?.pushViewController(nextVC, animated: true)
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
    }
}
