//
//  StepTwoKoreanDiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/05.
//

import UIKit

// MARK: - StepTwoKoreanDiaryViewController

final class StepTwoKoreanDiaryViewController: DiaryViewController {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNagivationBarDelegate()
    }
}

// MARK: - Extensions

extension StepTwoKoreanDiaryViewController {
    private func setNagivationBarDelegate() {
        rootView.setNavigationBarDelegate(self)
    }
    
    private func handleHintButton() {
        let isHintShowed = viewModel.onUpdateHintButton.value
        
        rootView.bottomView.updateHintButtonImage(isHintShowed)
        
        if isHintShowed {
            postDeepLApi(diaryText: rootView.configuration.layoutConfig?.getHintViewText() ?? "")
        } else {
            rootView.configuration.layoutConfig?.hintTextView.text = viewModel.model.hintText
        }
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

// MARK: - HintActionDelegate

extension StepTwoKoreanDiaryViewController {
    func didTapHintButton() {
        viewModel.toggleIsHintShowed()
        handleHintButton()
        AmplitudeManager.shared.track(event: AmplitudeConstant.diary.hint_click.event)
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
