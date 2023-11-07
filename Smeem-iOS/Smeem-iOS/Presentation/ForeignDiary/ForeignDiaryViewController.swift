//
//  ForeignDiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/05.
//

import UIKit

final class ForeignDiaryViewController: DiaryViewController {
    
    override func didTapLeftButton() {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    override func didTapRightButton() {
        if rootView?.navigationView.rightButton.titleLabel?.textColor == .point {
//            showLodingView(loadingView: rootView.loadingView)
            postDiaryAPI()
        } else {
            //            showToastIfNeeded(toastType: .defaultToast(bodyType: .regEx))
        }
    }
}

extension ForeignDiaryViewController {
    static func createWithForeignDiaryiew() -> ForeignDiaryViewController {
        let diaryViewFactory = DiaryViewFactory()
        let foreignDiaryView = diaryViewFactory.createForeginDiaryView()
        return ForeignDiaryViewController(rootView: foreignDiaryView)
    }
}
