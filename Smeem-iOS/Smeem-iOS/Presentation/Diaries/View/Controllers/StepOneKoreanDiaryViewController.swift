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
    
    // MARK: - Properties
    
    weak var delegate: DataBindProtocol?
    
    private let viewFactory = DiaryViewFactory()
    
    private var cancelBag = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(viewModel: StepOneKoreanDiaryViewModel) {
        super.init(rootView: viewFactory.createStepOneKoreanDiaryView(), viewModel: viewModel)
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNagivationBarDelegate()
        handleInitialRandomTopicApiCall()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideKeyboard()
    }
}

// MARK: - Bind

extension StepOneKoreanDiaryViewController {
    private func bind() {
        let input = StepOneKoreanDiaryViewModel.Input(randomTopicButtonTapped: rootView.bottomView.randomTopicButtonTapped,
                                         refreshButtonTapped: rootView.randomTopicView.refreshButtonTapped)
        
        let output = viewModel.transform(input: input)
        
        output.randomTopicButtonAction
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
                let isActive = self.viewModel.isRandomTopicActive.value
                let content = self.viewModel.topicContentSubject.value
                
                self.checkGuidToolTip()
                self.rootView.bottomView.updateRandomTopicButtonImage(isActive)
                self.rootView.updateRandomTopicView(isRandomTopicActive: isActive)
                self.rootView.updateInputTextViewConstraints(isRandomTopicActive: isActive)
                self.rootView.randomTopicView.updateText(with: content)
            }
            .store(in: &cancelBag)
        
        output.refreshButtonAction
            .receive(on: DispatchQueue.main)
            .sink { _ in
                let content = self.viewModel.topicContentSubject.value
                
                self.rootView.randomTopicView.updateText(with: content)
            }
            .store(in: &cancelBag)
    }
}


// MARK: - Extensions

extension StepOneKoreanDiaryViewController {
    private func setNagivationBarDelegate() {
        rootView.setNavigationBarDelegate(self)
    }
    
    // MARK: - Action Helpers
    
    private func handleRightNavigationButton() {
//        let diaryViewControllerFactory = DiaryViewControllerFactory(diaryViewFactory: DiaryViewFactory(), viewModel: DiaryViewModel(model: DiaryModel()))
//        let nextVC = diaryViewControllerFactory.makeStepTwoKoreanDiaryViewController()
//        delegate = nextVC
//        
//        let inputText = viewModel.inputText.value
//        
//        delegate?.dataBind(topicID: viewModel.getTopicID(), inputText: inputText ?? "")
        
//        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - NavigationBarActionDelegate

extension StepOneKoreanDiaryViewController: NavigationBarActionDelegate {
    func didTapLeftButton() {
        rootView.removeToolTip()
        presentingViewController?.dismiss(animated: true)
    }
    
    func didTapRightButton() {
//        if viewModel.onUpdateTextValidation.value == true {
//            if viewModel.isRandomTopicActive.value == false {
//                viewModel.updateTopicID(topicID: nil)
//            }
//            rootView.inputTextView.resignFirstResponder()
//            handleRightNavigationButton()
//            AmplitudeManager.shared.track(event: AmplitudeConstant.diary.first_step_complete.event)
//        } else {
//            viewModel.showRegExKrToast()
//        }
    }
}
