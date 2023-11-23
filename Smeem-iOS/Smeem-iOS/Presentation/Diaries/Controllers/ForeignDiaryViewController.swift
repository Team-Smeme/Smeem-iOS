//
//  ForeignDiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/05.
//

import UIKit

// MARK: - ForeignDiaryViewController

final class ForeignDiaryViewController: DiaryViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarButtonActionStrategy(ForeignDiaryNavigationAction(viewController: self))
    }
}

// MARK: - Extensions

extension ForeignDiaryViewController {
    static func createWithForeignDiaryiew() -> ForeignDiaryViewController {
        let diaryViewFactory = DiaryViewFactory()
        let foreignDiaryView = diaryViewFactory.createForeginDiaryView()
        let viewModel = DiaryViewModel()
        return ForeignDiaryViewController(rootView: foreignDiaryView, viewModel: viewModel)
    }
}
