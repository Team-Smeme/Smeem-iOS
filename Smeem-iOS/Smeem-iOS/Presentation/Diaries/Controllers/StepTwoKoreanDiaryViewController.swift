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
        setHintButtonDelegate()
    }
}

// MARK: - Extensions

extension StepTwoKoreanDiaryViewController {
    static func createWithStepTwoKoreanDiaryView() -> StepTwoKoreanDiaryViewController {
        let diaryViewFactory = DiaryViewFactory()
        let stepTwoKoreanDiaryView = diaryViewFactory.createStepTwoKoreanDiaryView()
        let viewModel = DiaryViewModel()
        return StepTwoKoreanDiaryViewController(rootView: stepTwoKoreanDiaryView, viewModel: viewModel)
    }
    
    private func setNagivationBarDelegate() {
        rootView?.setNavigationBarDelegate(self)
    }
    
    private func setHintButtonDelegate() {
        rootView?.setHintButtonDelegate(self)
    }
    
    private func handleHintButton() {
        guard let isHintShowed = viewModel?.isHintShowed.value else { return }
        
        rootView?.bottomView.updateHintButtonImage(isHintShowed)
        
        if isHintShowed {
            postDeepLApi(diaryText: rootView?.configuration.layoutConfig?.getHintViewText() ?? "")
        } else {
            rootView?.configuration.layoutConfig?.hintTextView.text = viewModel?.hintText
        }
    }
}

// MARK: - NavigationBarActionDelegate

extension StepTwoKoreanDiaryViewController: NavigationBarActionDelegate {
    func didTapLeftButton() {
        navigationController?.popViewController(animated: true)
    }
    
    func didTapRightButton() {
        if rootView?.navigationView.rightButton.titleLabel?.textColor == .point {
            rootView?.inputTextView.resignFirstResponder()
            viewModel?.postDiaryAPI { postDiaryResponse in
                self.handlePostDiaryResponse(postDiaryResponse)
            }
            AmplitudeManager.shared.track(event: AmplitudeConstant.diary.sec_step_complete.event)
        } else {
            viewModel?.showRegExToast()
        }
    }
}

// MARK: - DataBindProtocol

extension StepTwoKoreanDiaryViewController: DataBindProtocol {
    func dataBind(topicID: Int?, inputText: String) {
        viewModel?.topicID = topicID
        rootView?.configuration.layoutConfig?.hintTextView.text = inputText
    }
}

// MARK: - HintActionDelegate

extension StepTwoKoreanDiaryViewController: HintActionDelegate {
    func didTapHintButton() {
        viewModel?.toggleIsHintShowed()
        handleHintButton()
        AmplitudeManager.shared.track(event: AmplitudeConstant.diary.hint_click.event)
    }
}

// MARK: - Network

extension StepTwoKoreanDiaryViewController {
    func postDeepLApi(diaryText: String) {
        DeepLAPI.shared.postTargetText(text: diaryText) { [weak self] response in
            self?.viewModel?.hintText = diaryText
            self?.rootView?.configuration.layoutConfig?.hintTextView.text.removeAll()
            self?.rootView?.configuration.layoutConfig?.hintTextView.text = response?.translations.first?.text
        }
    }
}
