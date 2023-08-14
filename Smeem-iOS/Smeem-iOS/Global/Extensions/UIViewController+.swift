//
//  UIViewController+.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/05/01.
//

import UIKit

extension UIViewController {
    
    /// 화면 진입시 키보드 바로 올라오게 해 주는 메서드
    func showKeyboard(textView: UIView) {
        textView.becomeFirstResponder()
    }
    
    /// 화면밖 터치시 키보드를 내려 주는 메서드
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    /// 키보드의 높이에 따라 해당 customView 위치를 변경해 주는 메서드(SE 기기대응 포함)
    func handleKeyboardChanged(notification: Notification, customView: UIView, isActive: Bool) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let safeAreaHeight = self.view.safeAreaInsets.bottom
            
            UIView.animate(withDuration: 1) {
                customView.transform = UIScreen.main.hasNotch ? (isActive ? CGAffineTransform(translationX: 0, y: -(keyboardHeight - safeAreaHeight)) : .identity) : (isActive ? CGAffineTransform(translationX: 0, y: -keyboardHeight) : .identity)
            }
        }
    }
    
    func getDeviceWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    func getDeviceHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    /// Constraint 설정 시 노치 유무로 기기를 대응하는 상황에서 사용
    func constraintByNotch(_ hasNotch: CGFloat, _ noNotch: CGFloat) -> CGFloat {
        return UIScreen.main.hasNotch ? hasNotch : noNotch
    }
    
    /// 노치 유무에 따른 상단 Status Bar 부분 크기에 따른 높이
    func headerHeightByNotch(_ height: CGFloat) -> CGFloat {
        return (UIScreen.main.hasNotch ? 44 : 10) + height
    }
    
    /// 노치 유무에 따른 하단 부분 크기에 따른 높이
    func bottomHeightByNotch(_ height: CGFloat) -> CGFloat {
        return (UIScreen.main.hasNotch ? 34 : 0) + height
    }
    
    /// 아이폰 13 미니(width 375)를 기준으로 레이아웃을 잡고, 기기의 width 사이즈를 곱해 대응 값을 구할 때 사용
    func convertByWidthRatio(_ convert: CGFloat) -> CGFloat {
        return (convert / 375) * getDeviceWidth()
    }
    
    /// 아이폰 13 미니(height 812)를 기준으로 레이아웃을 잡고, 기기의 height 사이즈를 곱해 대응 값을 구할 때 사용
    func convertByHeightRatio(_ convert: CGFloat) -> CGFloat {
        return (convert / 812) * getDeviceHeight()
    }
    
    /// 상단 네비바 hidden
    func hiddenNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    /// 부분 글자 스타일 변경 함수
    func changePartialStringStyle(mainString: String,
                                  pointString: String,
                                  pointFont: UIFont,
                                  pointColor: UIColor) -> NSMutableAttributedString {
        let range = (mainString as NSString).range(of: pointString)
        
        let attributedString = NSMutableAttributedString(string: mainString)
        attributedString.addAttribute(.font, value: pointFont, range: range)
        attributedString.addAttribute(.foregroundColor, value: pointColor, range: range)
        
        return attributedString
    }
    
    func changeRootViewControllerAndPresent(_ viewControllerToPresent: UIViewController) {
         if let window = UIApplication.shared.windows.first {
             window.rootViewController = viewControllerToPresent
             UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
         } else {
             viewControllerToPresent.modalPresentationStyle = .overFullScreen
             self.present(viewControllerToPresent, animated: true, completion: nil)
         }
     }

    func changeRootViewController(_ viewController: UIViewController) {
        guard let window = UIApplication.shared.windows.first else { return }
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            let rootVC = UINavigationController(rootViewController: viewController)
            window.rootViewController = rootVC
        })
    }
    
    /// showLodingView
    func showLodingView(loadingView: LoadingView) {
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        loadingView.isLoading = true
    }
    
    func hideLodingView(loadingView: LoadingView) {
        loadingView.isLoading = false
    }
    
    func presentOnboardingPlanVC() {
        let onboardingGoalVC = GoalOnboardingViewController()
        self.navigationController?.pushViewController(onboardingGoalVC, animated: true)
    }
    
    func presentOnboardingAcceptVC() {
        let bottomSheetVC = BottomSheetViewController()
        let onboardingAcceptVC = UserNicknameViewController()
        onboardingAcceptVC.userPlanRequest = bottomSheetVC.userPlanRequest
        let _ = UINavigationController(rootViewController: onboardingAcceptVC)
        self.navigationController?.pushViewController(onboardingAcceptVC, animated: true)
        
    }
    
    func presentHomeVC() {
        let onboardingAcceptVC = HomeViewController()
        changeRootViewController(onboardingAcceptVC)
    }
    
    func presentSmeemStartVC() {
        let smeemStartVC = SmeemStartViewController()
        changeRootViewController(smeemStartVC)
    }
}
