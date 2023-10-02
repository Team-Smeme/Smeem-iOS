//
//  StepOneKoreanDiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/05.
//

import UIKit

import SnapKit

final class StepOneKoreanDiaryViewController: DiaryViewController {
    
    // MARK: - Property
    
    weak var delegate: DataBindProtocol?
    
    private let tipLabel: UILabel = {
        let label = UILabel()
        label.text = "TIP"
        label.font = .c3
        label.textColor = .point
        return label
    }()
    
    private lazy var cancelTipButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnCancelGrey, for: .normal)
        return button
    }()
    
    // MARK: - Custom Method
    
    private func handleLeftNavigationButton() {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    private func handleRightNavigationButton() {
        let stepTwoVC = StepTwoKoreanDiaryViewController()
        delegate = stepTwoVC
        
        if let text = self.inputTextView.text {
            delegate?.dataBind(topicID: topicID, inputText: text)
        }
        
        self.navigationController?.pushViewController(stepTwoVC, animated: true)
    }
}

extension StepOneKoreanDiaryViewController: NavigationBarActionDelegate {
    func leftButtonDidTap() {
        handleLeftNavigationButton()
    }
    
    func rightButtonDidTap() {
        if rightNavigationButton.titleLabel?.textColor == .point {
            handleRightNavigationButton()
        } else {
            showToastIfNeeded(toastType: .defaultToast(bodyType: .regEx))
        }
    }
}
