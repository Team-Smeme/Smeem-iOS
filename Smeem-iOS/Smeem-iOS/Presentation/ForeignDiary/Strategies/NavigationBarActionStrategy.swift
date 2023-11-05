//
//  LeftButtonActionStrategy.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/10/25.
//

import UIKit

protocol LeftButtonActionStrategy {
    func performLeftButtonAction()
}

protocol RightButtonActionStrategy {
    func performRightButtonAction()
}

class DismissLeftButtonActionStrategy: LeftButtonActionStrategy {
    
    private weak var viewController: UIViewController?
    
    init(viewContoller: UIViewController? = nil) {
        self.viewController = viewContoller
    }
    
    func performLeftButtonAction() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}

class PostDiaryRightButtonActionStrategy: RightButtonActionStrategy {
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
    func performRightButtonAction() {

        let stepTwoVC = StepTwoKoreanDiaryViewController.createWithStepTwoKoreanDiaryView()
        
        viewController?.navigationController?.pushViewController(stepTwoVC, animated: true)
    }
}

class GotoStepTwoRightButtonActionStrategy: RightButtonActionStrategy {
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
    
    func performRightButtonAction() {
        print("performRightButtonAction")
    }
}
