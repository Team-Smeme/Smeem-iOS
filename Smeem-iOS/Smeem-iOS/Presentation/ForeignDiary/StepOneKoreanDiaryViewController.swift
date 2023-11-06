//
//  StepOneKoreanDiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/05.
//

import UIKit

import SnapKit

final class StepOneKoreanDiaryViewController: DiaryViewController {
    
    // MARK: - Properties
    
    weak var delegate: DataBindProtocol?
    
    // MARK: - Navigations
    
    override func didTapLeftButton() {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    override func didTapRightButton() {
        handleRightNavigationButton()
    }
}

extension StepOneKoreanDiaryViewController {
    static func createWithStepOneKoreanDiaryView() -> StepOneKoreanDiaryViewController {
        let diaryViewFactory = DiaryViewFactory()
        let stepOneKoreanDiaryView = diaryViewFactory.createStepOneKoreanDiaryView()
        return StepOneKoreanDiaryViewController(rootView: stepOneKoreanDiaryView)
    }
    
    private func handleRightNavigationButton() {
        let nextVC = StepTwoKoreanDiaryViewController.createWithStepTwoKoreanDiaryView()
        delegate = nextVC
        
        delegate?.dataBind(topicID: getTopicID(), inputText: getInputText())
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

//extension StepOneKoreanDiaryViewController: NavigationBarActionDelegate {
//    func didTapRightButton() {
//        if rightNavigationButton.titleLabel?.textColor == .point {
//            handleRightNavigationButton()
//        } else {
//            showToastIfNeeded(toastType: .defaultToast(bodyType: .regEx))
//        }
//    }
//}
