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
    
    private var cancelBag = Set<AnyCancellable>()
    
    private let viewFactory = DiaryViewFactory()
    
    // MARK: - Life Cycle
    
    init(viewModel: StepTwoKoreanDiaryViewModel) {
        super.init(rootView: viewFactory.createStepTwoKoreanDiaryView(), viewModel: viewModel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNagivationBarDelegate()
        bind()
    }
}

extension StepTwoKoreanDiaryViewController {
    private func bind() {
        let input = StepTwoKoreanDiaryViewModel.Input(leftButtonTapped: rootView.navigationView.leftButtonTapped,
                                                      rightButtonTapped: rootView.navigationView.rightButtonTapped,
                                                      hintButtonTapped: rootView.bottomView.hintButtonTapped)
        
        let output = viewModel.transform(input: input)
        
        output.leftButtonAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.rootView.removeToolTip()
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancelBag)
        
//        output.hintButtonAction
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] in
//                // TODO: 수정 필요
//                self?.viewModel.toggleIsHintShowed()
//                guard let isHintShowed = self?.viewModel.onUpdateHintButton.value
//                else { return }
//                
//                self?.rootView.bottomView.updateHintButtonImage(isHintShowed)
//            }
//            .store(in: &cancelBag)

    }
}

// MARK: - Extensions

extension StepTwoKoreanDiaryViewController {
    private func setNagivationBarDelegate() {
        rootView.setNavigationBarDelegate(self)
    }
    
    private func handleHintButton() {

    }
}

// MARK: - NavigationBarActionDelegate

extension StepTwoKoreanDiaryViewController: NavigationBarActionDelegate {
    func didTapLeftButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func didTapRightButton() {
        if viewModel.onUpdateTextValidation.value == true {
            // TODO: 다듬읍시다..
            rootView.inputTextView.resignFirstResponder()
            viewModel.postDiaryAPI { postDiaryResponse in
                self.handlePostDiaryResponse(postDiaryResponse)
            }
            AmplitudeManager.shared.track(event: AmplitudeConstant.diary.sec_step_complete.event)
        } else {
            viewModel.showRegExToast()
        }
    }
}

// MARK: - DataBindProtocol

extension StepTwoKoreanDiaryViewController: DataBindProtocol {
    func dataBind(topicID: Int?, inputText: String) {
        viewModel.updateTopicID(topicID: topicID)
        rootView.configuration.layoutConfig?.hintTextView.text = inputText
    }
}

// MARK: - Network

extension StepTwoKoreanDiaryViewController {
    func postDeepLApi(diaryText: String) {
        DeepLAPI.shared.postTargetText(text: diaryText) { [weak self] response in
            self?.viewModel.updateHintText(hintText: diaryText)
            self?.rootView.configuration.layoutConfig?.hintTextView.text.removeAll()
            self?.rootView.configuration.layoutConfig?.hintTextView.text = response?.translations.first?.text
        }
    }
}
