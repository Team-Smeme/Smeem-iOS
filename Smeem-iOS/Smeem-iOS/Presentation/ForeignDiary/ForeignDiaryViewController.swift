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
        
        setNavigationBarButtonActionStrategy(ForeignDiaryNavigationAction(viewController: self))
    }
}

extension ForeignDiaryViewController {
    static func createWithForeignDiaryiew() -> ForeignDiaryViewController {
        let diaryViewFactory = DiaryViewFactory()
        let foreignDiaryView = diaryViewFactory.createForeginDiaryView()
        return ForeignDiaryViewController(rootView: foreignDiaryView)
    }
}
