//
//  StepTwoKoreanDiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/05.
//

import UIKit

final class StepTwoKoreanDiaryViewController: DiaryViewController {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHintButtonDelegate()
    }
    
    // MARK: - Navigation
    
    override func didTapLeftButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didTapRightButton() {
        if rootView?.navigationView.rightButton.titleLabel?.textColor == .point {
//            showLodingView(loadingView: rootView.loadingView)
            postDiaryAPI()
        } else {
            //            showToastIfNeeded(toastType: .defaultToast(bodyType: .regEx))
        }
    }
}

// MARK: - Extensions

extension StepTwoKoreanDiaryViewController {
    static func createWithStepTwoKoreanDiaryView() -> StepTwoKoreanDiaryViewController {
        let diaryViewFactory = DiaryViewFactory()
        let stepTwoKoreanDiaryView = diaryViewFactory.createStepTwoKoreanDiaryView()
        return StepTwoKoreanDiaryViewController(rootView: stepTwoKoreanDiaryView)
    }
    
    func setHintButtonDelegate() {
        rootView?.setHintButtonDelegate(self)
    }
    
    func handleHintButton() {
        guard let isHintShowed = viewModel?.isHintShowed else { return }
        
        rootView?.bottomView.updateHintButtonImage(isHintShowed)
        
        if isHintShowed {
            postPapagoApi(diaryText: rootView?.configuration.layoutConfig?.getHintViewText() ?? "")
        } else {
            rootView?.configuration.layoutConfig?.hintTextView.text = viewModel?.hintText
        }
    }
}

// MARK: - DataBindProtocol

extension StepTwoKoreanDiaryViewController: DataBindProtocol {
    func dataBind(topicID: String?, inputText: String) {
        viewModel?.topicID = topicID
        rootView?.configuration.layoutConfig?.hintTextView.text = inputText
    }
}

// MARK: - HintActionDelegate

extension StepTwoKoreanDiaryViewController: HintActionDelegate {
    func didTapHintButton() {
        viewModel?.toggleIsHintShowed()
        handleHintButton()
    }
}

// MARK: - Network

extension StepTwoKoreanDiaryViewController {
    func postPapagoApi(diaryText: String) {
        PapagoAPI.shared.postDiary(param: diaryText) { response in
            guard let response = response else { return }
            self.viewModel?.hintText = diaryText
            self.rootView?.configuration.layoutConfig?.hintTextView.text.removeAll()
            self.rootView?.configuration.layoutConfig?.hintTextView.text = response.message.result.translatedText
        }
    }
}




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
