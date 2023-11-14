//
//  NavigationActionStrategy.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/11/07.
//

protocol NavigationActionStrategy {
    associatedtype viewcontrollerType: DiaryViewController
    var viewController: viewcontrollerType? { get set }
    
    func performLeftButtonAction()
    func performRightButtonAction()
}

class DefaultNavigationActionStrategy: NavigationActionStrategy {
    typealias viewcontrollerType = DiaryViewController
    
    var viewController: viewcontrollerType?
    
    func performLeftButtonAction() {
        print("DefaultNavigationActionStrategy")
    }
    
    func performRightButtonAction() {
        print("DefaultNavigationActionStrategy")
    }
}

class ForeignDiaryNavigationAction: NavigationActionStrategy {
    typealias viewcontrollerType = ForeignDiaryViewController
    
    var viewController: viewcontrollerType?
    
    init(viewController: viewcontrollerType? = nil) {
        self.viewController = viewController
    }
    
    func performLeftButtonAction() {
        viewController?.presentingViewController?.dismiss(animated: true)
    }
    
    func performRightButtonAction() {
        if viewController?.rootView?.navigationView.rightButton.titleLabel?.textColor == .point {
//            viewController?.showLodingView(loadingView: rootView.loadingView)
            viewController?.viewModel?.inputText.value = viewController?.rootView?.inputTextView.text ?? ""
            viewController?.rootView?.inputTextView.resignFirstResponder()
            viewController?.viewModel?.postDiaryAPI { postDiaryResponse in
                self.viewController?.handlePostDiaryResponse(postDiaryResponse)
            }
        } else {
//            showToastIfNeeded(toastType: .defaultToast(bodyType: .regEx))
        }
    }
}

class StepOneKoreanDiaryNavigationAction: NavigationActionStrategy {
    typealias viewcontrollerType = StepOneKoreanDiaryViewController
    
    var viewController: viewcontrollerType?
    
    init(viewController: viewcontrollerType?) {
        self.viewController = viewController
    }
    
    func performLeftButtonAction() {
        viewController?.presentingViewController?.dismiss(animated: true)
    }
    
    func performRightButtonAction() {
        if viewController?.rootView?.navigationView.rightButton.titleLabel?.textColor == .point {
//            showLodingView(loadingView: rootView.loadingView)
            viewController?.rootView?.inputTextView.resignFirstResponder()
            viewController?.handleRightNavigationButton()
        } else {
            //            showToastIfNeeded(toastType: .defaultToast(bodyType: .regEx))
        }
    }
}

class StepTwoKoreanDiaryNavigationAction: NavigationActionStrategy {
    typealias viewcontrollerType = StepTwoKoreanDiaryViewController
    
    var viewController: viewcontrollerType?
    
    init(viewController: viewcontrollerType?) {
        self.viewController = viewController
    }
    
    func performLeftButtonAction() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func performRightButtonAction() {
        if viewController?.rootView?.navigationView.rightButton.titleLabel?.textColor == .point {
//            showLodingView(loadingView: rootView.loadingView)
            viewController?.rootView?.inputTextView.resignFirstResponder()
            viewController?.viewModel?.postDiaryAPI { postDiaryResponse in
                self.viewController?.handlePostDiaryResponse(postDiaryResponse)
            }
        } else {
            //            showToastIfNeeded(toastType: .defaultToast(bodyType: .regEx))
        }
    }
}
