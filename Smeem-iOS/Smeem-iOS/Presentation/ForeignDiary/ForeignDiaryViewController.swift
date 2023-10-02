//
//  ForeignDiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/05.
//

import UIKit

final class ForeignDiaryViewController: DiaryViewController {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        handleRightNavitationButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //        randomSubjectToolTip?.removeFromSuperview()
    }
}

extension ForeignDiaryViewController: UINavigationControllerDelegate {
    func didTapLeftButton() {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    func didTapRightButton() {
//        if .navigationView.rightButton.titleLabel?.textColor == .point {
//            showLodingView(loadingView: self.loadingView)
//            postDiaryAPI()
//        } else {
//            showToastIfNeeded(toastType: .defaultToast(bodyType: .regEx))
//        }
    }
}
