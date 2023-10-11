//
//  BaseViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/10/02.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hiddenNavigationBar()
        setBackgroundColor()
        swipeRecognizer()
        setButtonAction()
    }
    
    func setBackgroundColor() {
        view.backgroundColor = .smeemWhite
    }
    
    func hiddenNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setButtonAction() { }
    
    func swipeRecognizer() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(responseToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    @objc func responseToSwipeGesture() {
        self.navigationController?.popViewController(animated: true)
    }
}
