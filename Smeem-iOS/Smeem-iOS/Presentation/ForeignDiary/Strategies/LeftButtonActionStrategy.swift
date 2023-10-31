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

class DismissLeftButtonActionStrategy: LeftButtonActionStrategy {
    
    private weak var viewContoller: UIViewController?
    
    init(viewContoller: UIViewController? = nil) {
        self.viewContoller = viewContoller
    }
    
    func performLeftButtonAction() {
        viewContoller?.dismiss(animated: true, completion: nil)
    }
}
