//
//  ForeignDiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/05.
//

import UIKit

final class ForeignDiaryViewController: DiaryViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        handleRightNavitationButton()
    }
    
    private func handleRightNavitationButton() {
        rightNavigationButton.addTarget(self, action: #selector(rightNavigationButtonDidTap), for: .touchUpInside)
    }
    
    override func rightNavigationButtonDidTap() {
        if rightNavigationButton.titleLabel?.textColor == .point {
            postDiaryAPI()
            let homeVC = HomeViewController()
            homeVC.badgePopupData = self.badgePopupContent
            let rootVC = UINavigationController(rootViewController: homeVC)
            changeRootViewControllerAndPresent(rootVC)
        } else {
            view.addSubview(regExToastView)
            regExToastView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(bottomView.snp.top).offset(-20)
            }
            regExToastView.show()
        }
    }
}
