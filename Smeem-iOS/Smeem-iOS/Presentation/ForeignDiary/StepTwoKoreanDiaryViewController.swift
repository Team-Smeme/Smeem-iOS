//
//  StepTwoKoreanDiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/05.
//

import UIKit

import SnapKit

final class StepTwoKoreanDiaryViewController: DiaryViewController {
    
    // MARK: - Properties
    
    var isHintShowed: Bool = false
    var hintText: String?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        handleRightNavitationButton()
    }
    
    // MARK: - Navigation
    
    override func didTapLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didTapRightButton() {
        print("didTapRightButton")
    }
}

extension StepTwoKoreanDiaryViewController {
    
    // MARK: - Custom Method
    
    //    private func handleRightNavitationButton() {
    //        rightNavigationButton.addTarget(self, action: #selector(rightNavigationButtonDidTap), for: .touchUpInside)
    //    }
    
    static func createWithStepTwoKoreanDiaryView() -> StepTwoKoreanDiaryViewController {
        let diaryViewFactory = DiaryViewFactory()
        let stepTwoKoreanDiaryView = diaryViewFactory.createStepTwoKoreanDiaryView()
        return StepTwoKoreanDiaryViewController(rootView: stepTwoKoreanDiaryView)
    }
}

// MARK: - DataBindProtocol

extension StepTwoKoreanDiaryViewController: DataBindProtocol {
    func dataBind(topicID: Int?, inputText: String) {
        viewModel?.topicID = topicID
        rootView?.configuration.layoutConfig?.hintTextView.text = inputText
    }
}

// MARK: - Network

extension StepTwoKoreanDiaryViewController {
    func postPapagoApi(diaryText: String) {
        PapagoAPI.shared.postDiary(param: diaryText) { response in
            guard let response = response else { return }
            //            self.hintText = self.hintTextView.text
            //            self.hintTextView.text.removeAll()
            //            self.hintTextView.text = response.message.result.translatedText
        }
    }
}

// MARK: - NavigationBarActionDelegate

//extension StepTwoKoreanDiaryViewController: NavigationBarActionDelegate {
//
//    func didTapRightButton() {
//        if rightNavigationButton.titleLabel?.textColor == .point {
//            self.hideLodingView(loadingView: self.loadingView)
//            postDiaryAPI()
//        } else {
//            showToastIfNeeded(toastType: .defaultToast(bodyType: .regEx))
//        }
//    }
//}


// MARK: - Tutorial

//extension StepTwoKoreanDiaryViewController {
//    private func checkTutorial() {
//        let tutorialDiaryStepTwo = UserDefaultsManager.tutorialDiaryStepTwo
//
//        if !tutorialDiaryStepTwo {
//            UserDefaultsManager.tutorialDiaryStepTwo = true
//
//            view.addSubviews(tutorialImageView ?? UIImageView(), dismissButton ?? UIButton())
//
//            tutorialImageView?.snp.makeConstraints {
//                $0.top.leading.trailing.bottom.equalToSuperview()
//            }
//            dismissButton?.snp.makeConstraints {
//                $0.top.equalToSuperview().inset(convertByHeightRatio(371))
//                $0.trailing.equalToSuperview().inset(convertByHeightRatio(10))
//                $0.width.height.equalTo(convertByHeightRatio(45))
//            }
//        } else {
//            tutorialImageView = nil
//            dismissButton = nil
//        }
//    }
//}
