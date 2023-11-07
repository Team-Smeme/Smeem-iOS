//
//  StepOneKoreanDiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/05.
//

import UIKit

final class StepOneKoreanDiaryViewController: DiaryViewController {
    
    // MARK: - Properties
    
    weak var delegate: DataBindProtocol?
    
    // MARK: - Navigations
    
    override func didTapLeftButton() {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    override func didTapRightButton() {
        if rootView?.navigationView.rightButton.titleLabel?.textColor == .point {
//            showLodingView(loadingView: rootView.loadingView)
            handleRightNavigationButton()
        } else {
            //            showToastIfNeeded(toastType: .defaultToast(bodyType: .regEx))
        }
    }
}

// MARK: - Extensions

extension StepOneKoreanDiaryViewController {
    static func createWithStepOneKoreanDiaryView() -> StepOneKoreanDiaryViewController {
        let diaryViewFactory = DiaryViewFactory()
        let stepOneKoreanDiaryView = diaryViewFactory.createStepOneKoreanDiaryView()
        return StepOneKoreanDiaryViewController(rootView: stepOneKoreanDiaryView)
    }
    
    // MARK: Action Helpers
    private func handleRightNavigationButton() {
        let nextVC = StepTwoKoreanDiaryViewController.createWithStepTwoKoreanDiaryView()
        delegate = nextVC
        
        delegate?.dataBind(topicID: getTopicID(), inputText: getInputText())
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
