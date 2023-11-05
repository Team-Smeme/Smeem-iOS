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
    
    // MARK: - UI Properties
    
//    private let tipLabel: UILabel = {
//        let label = UILabel()
//        label.text = "TIP"
//        label.font = .c3
//        label.textColor = .point
//        return label
//    }()
//
//    private lazy var cancelTipButton: UIButton = {
//        let button = UIButton()
//        button.setImage(Constant.Image.icnCancelGrey, for: .normal)
//        return button
//    }()
    
    override func didTapLeftButton() {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    override func didTapRightButton() {
        let nextVC = StepTwoKoreanDiaryViewController.createWithStepTwoKoreanDiaryView()
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension StepOneKoreanDiaryViewController {
    static func createWithStepOneKoreanDiaryView() -> StepOneKoreanDiaryViewController {
        let diaryViewFactory = DiaryViewFactory()
        let stepOneKoreanDiaryView = diaryViewFactory.createStepOneKoreanDiaryView()
        return StepOneKoreanDiaryViewController(rootView: stepOneKoreanDiaryView)
    }
    
//    private func handleRightNavigationButton() {
//        let stepTwoVC = StepTwoKoreanDiaryViewController()
//        delegate = stepTwoVC
//
//        if let text = inputTextView.text {
//            delegate?.dataBind(topicID: topicID, inputText: text)
//        }
//
//        self.navigationController?.pushViewController(stepTwoVC, animated: true)
//    }
}

//extension StepOneKoreanDiaryViewController: NavigationBarActionDelegate {
//    func didTapLeftButton() {
//        self.presentingViewController?.dismiss(animated: true)
//    }
//
//    func didTapRightButton() {
//        if rightNavigationButton.titleLabel?.textColor == .point {
//            handleRightNavigationButton()
//        } else {
//            showToastIfNeeded(toastType: .defaultToast(bodyType: .regEx))
//        }
//    }
//}
