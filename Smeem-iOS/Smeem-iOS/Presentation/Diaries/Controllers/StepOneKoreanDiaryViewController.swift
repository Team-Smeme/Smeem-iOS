//
//  StepOneKoreanDiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/05.
//

import UIKit

// MARK: - StepOneKoreanDiaryViewController

final class StepOneKoreanDiaryViewController: DiaryViewController {
    
    // MARK: Properties
    weak var delegate: DataBindProtocol?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNagivationBarDelegate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideKeyboard()
    }
}

// MARK: - Extensions

extension StepOneKoreanDiaryViewController {
    static func createWithStepOneKoreanDiaryView() -> StepOneKoreanDiaryViewController {
        let diaryViewFactory = DiaryViewFactory()
        let stepOneKoreanDiaryView = diaryViewFactory.createStepOneKoreanDiaryView()
        let viewModel = DiaryViewModel()
        return StepOneKoreanDiaryViewController(rootView: stepOneKoreanDiaryView, viewModel: viewModel)
    }
    
    private func setNagivationBarDelegate() {
        rootView?.setNavigationBarDelegate(self)
    }
    
    // MARK: Action Helpers
    private func handleRightNavigationButton() {
        let nextVC = StepTwoKoreanDiaryViewController.createWithStepTwoKoreanDiaryView()
        delegate = nextVC
        
        let inputText = viewModel?.inputText.value
        
        delegate?.dataBind(topicID: viewModel?.getTopicID(), inputText: inputText ?? "")
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - NavigationBarActionDelegate

extension StepOneKoreanDiaryViewController: NavigationBarActionDelegate {
    func didTapLeftButton() {
        rootView?.removeToolTip()
        presentingViewController?.dismiss(animated: true)
    }
    
    func didTapRightButton() {
        if viewModel?.isTextValid.value == true {
            if viewModel?.isRandomTopicActive.value == false {
                viewModel?.topicID = nil
            }
            rootView?.inputTextView.resignFirstResponder()
            handleRightNavigationButton()
            AmplitudeManager.shared.track(event: AmplitudeConstant.diary.first_step_complete.event)
        } else {
            viewModel?.showRegExToast()
        }
    }
}
