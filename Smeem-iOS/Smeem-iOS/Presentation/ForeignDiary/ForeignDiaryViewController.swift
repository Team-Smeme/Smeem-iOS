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
        
    }
    
    override func didTapLeftButton() {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    override func didTapRightButton() {
        print("didTapRightButton")
    }
}

extension ForeignDiaryViewController {
    static func createWithForeignDiaryiew() -> ForeignDiaryViewController {
        let diaryViewFactory = DiaryViewFactory()
        let foreignDiaryView = diaryViewFactory.createForeginDiaryView()
        return ForeignDiaryViewController(rootView: foreignDiaryView)
    }
}

//extension ForeignDiaryViewController: NavigationBarActionDelegate {
//    func didTapLeftButton() {
//        self.presentingViewController?.dismiss(animated: true)
//    }
//
//    func didTapRightButton() {
////        if .navigationView.rightButton.titleLabel?.textColor == .point {
////            showLodingView(loadingView: self.loadingView)
////            postDiaryAPI()
////        } else {
//////            showToastIfNeeded(toastType: .defaultToast(bodyType: .regEx))
////        }
//    }
//}
