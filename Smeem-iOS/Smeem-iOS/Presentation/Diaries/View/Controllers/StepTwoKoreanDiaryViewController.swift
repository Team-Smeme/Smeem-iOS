//
//  StepTwoKoreanDiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/05.
//

import UIKit
import Combine

// MARK: - StepTwoKoreanDiaryViewController

final class StepTwoKoreanDiaryViewController: DiaryViewController<StepTwoKoreanDiaryViewModel> {
    
    // MARK: - Subjects

    private var cancelBag = Set<AnyCancellable>()
    
    // MARK: - Properties
    
    private let viewFactory = DiaryViewFactory()
    
    // MARK: - Life Cycle
    
    init(viewModel: StepTwoKoreanDiaryViewModel, text: String?) {
        super.init(rootView: viewFactory.createStepTwoKoreanDiaryView(), viewModel: viewModel)
        
        rootView.configuration.layoutConfig?.hintTextView.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 왜 viewDidLoad에서 해야하지?
        bind()
    }
}

extension StepTwoKoreanDiaryViewController {
    private func bind() {
        let input = StepTwoKoreanDiaryViewModel.Input(leftButtonTapped: rootView.navigationView.leftButtonTapped,
                                                      rightButtonTapped: rootView.navigationView.rightButtonTapped,
                                                      hintButtonTapped: rootView.bottomView.hintButtonTapped,
                                                      hintTextsubject: rootView.bottomView.hintTextSubject)
        
        let output = viewModel.transform(input: input)
        
        output.leftButtonAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.rootView.removeToolTip()
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancelBag)
        
        output.rightButtonAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
//                if viewModel.onUpdateTextValidation.value == true {
//                    // TODO: 다듬읍시다..
//                    rootView.inputTextView.resignFirstResponder()
//                    viewModel.postDiaryAPI { postDiaryResponse in
//                        self?.handlePostDiaryResponse(postDiaryResponse)
//                    }
//                    AmplitudeManager.shared.track(event: AmplitudeConstant.diary.sec_step_complete.event)
//                } else {
//                    viewModel.showRegExToast()
//                }
            }
            .store(in: &cancelBag)
        
        output.hintButtonAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
//                guard let isHintShowed = self?.viewModel.hint.value
//                else { return }
                
//                self?.rootView.bottomView.updateHintButtonImage(isHintShowed)
            }
            .store(in: &cancelBag)
    }
}

// MARK: - Network

extension StepTwoKoreanDiaryViewController {
    func postDeepLApi(diaryText: String) {
        DeepLAPI.shared.postTargetText(text: diaryText) { [weak self] response in
//            self?.viewModel.updateHintText(hintText: diaryText)
            self?.rootView.configuration.layoutConfig?.hintTextView.text.removeAll()
            self?.rootView.configuration.layoutConfig?.hintTextView.text = response?.translations.first?.text
        }
    }
}
