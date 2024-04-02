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
    private let viewFactory = DiaryViewFactory()
    
    private var cancelBag = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    
    init(viewModel:ForeignDiaryViewModel) {
        super.init(rootView: viewFactory.createStepOneKoreanDiaryView(), viewModel:viewModel )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideKeyboard()
    }
}

// MARK: - Extensions

extension ForeignDiaryViewController {
    private func bind() {
        let input = ForeignDiaryViewModel.Input(leftButtonTapped: rootView.navigationView.leftButtonTapped,
                                                rightButtonTapped: rootView.navigationView.rightButtonTapped,
                                                randomTopicButtonTapped: rootView.bottomView.randomTopicButtonTapped,
                                                refreshButtonTapped: rootView.randomTopicView.refreshButtonTapped)
        
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
            }
            .store(in: &cancelBag)
        
        output.randomTopicButtonAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let isActive = self?.viewModel.isRandomTopicActive.value,
                      let content = self?.viewModel.topicContentSubject.value
                else { return }
                
                self?.checkGuidToolTip()
                self?.rootView.bottomView.updateRandomTopicButtonImage(isActive)
                self?.rootView.updateRandomTopicView(isRandomTopicActive: isActive)
                self?.rootView.updateInputTextViewConstraints(isRandomTopicActive: isActive)
                self?.rootView.randomTopicView.updateText(with: content)
            }
            .store(in: &cancelBag)
        
        output.refreshButtonAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                let content = self?.viewModel.topicContentSubject.value
                
                self?.rootView.randomTopicView.updateText(with: content ?? "")
            }
            .store(in: &cancelBag)
    }
}

// MARK: - NavigationBarActionDelegate

extension ForeignDiaryViewController {
    func didTapRightButton() {
        //        if viewModel.onUpdateTextValidation.value == true {
        //            if viewModel.isRandomTopicActive.value == false {
        //                viewModel.updateTopicID(topicID: nil)
        //            }
        //            viewModel.inputText.value = rootView.inputTextView.text ?? ""
        //            rootView.inputTextView.resignFirstResponder()
        //            viewModel.postDiaryAPI { postDiaryResponse in
        //                self.handlePostDiaryResponse(postDiaryResponse)
        //            }
        //            AmplitudeManager.shared.track(event: AmplitudeConstant.diary.diary_complete.event)
        //        } else {
        //            viewModel.showRegExToast()
        //        }
    }
}
