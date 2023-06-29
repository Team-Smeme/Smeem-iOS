//
//  StepOneKoreanDiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/05.
//

import UIKit

final class StepOneKoreanDiaryViewController: DiaryViewController {
    
    // MARK: - Property
    
    weak var delegate: DataBindProtocol?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - @objc
    
    override func leftNavigationButtonDidTap() {
        handleLeftNavigationButton()
    }
    
    override func rightNavigationButtonDidTap() {
        handleRightNavigationButton()
    }
    
    // MARK: - Custom Method
    
    private func handleLeftNavigationButton() {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    private func handleRightNavigationButton() {
        let stepTwoVC = StepTwoKoreanDiaryViewController()
        delegate = stepTwoVC
        
        if let text = self.inputTextView.text {
            delegate?.dataBind(text: text)
        }
        
        let stepOneVC = StepOneKoreanDiaryViewController()
//        let navigationController = UINavigationController(rootViewController: stepOneVC)
        self.navigationController?.pushViewController(stepTwoVC, animated: true)
    }
}
