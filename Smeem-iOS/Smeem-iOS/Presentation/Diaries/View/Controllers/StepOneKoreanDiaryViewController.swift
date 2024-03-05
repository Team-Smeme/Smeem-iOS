//
//  StepOneKoreanDiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/05.
//

import UIKit

// MARK: - StepOneKoreanDiaryViewController

final class StepOneKoreanDiaryViewController: DiaryViewController {
    
    // MARK: - Properties
    
    weak var delegate: DataBindProtocol?
    
    // MARK: - Life Cycle
    
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

// MARK: - Extensions

extension StepOneKoreanDiaryViewController {
    private func setNagivationBarDelegate() {
        rootView?.setNavigationBarDelegate(self)
    }
    
    // MARK: - Action Helpers
    
    private func handleRightNavigationButton() {
        let diaryViewControllerFactory = DiaryViewControllerFactory(diaryViewFactory: DiaryViewFactory(), viewModel: DiaryViewModel(model: DiaryModel()))
        let nextVC = diaryViewControllerFactory.makeStepTwoKoreanDiaryViewController()
        delegate = nextVC
        
        delegate?.dataBind(topicID: viewModel.getTopicID(), inputText: viewModel.getInputText())
        
        print("데이터바인드 성공", viewModel.getTopicID())
        
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
        if viewModel.onUpdateTextValidation.value == true {
            if viewModel.isRandomTopicActive.value == false {
                viewModel.updateTopicID(topicID: nil)
            }
            rootView?.inputTextView.resignFirstResponder()
            handleRightNavigationButton()
            AmplitudeManager.shared.track(event: AmplitudeConstant.diary.first_step_complete.event)
        } else {
            viewModel.showRegExKrToast()
        }
    }
}
