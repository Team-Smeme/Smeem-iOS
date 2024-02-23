//
//  DiaryViewControllerFactory.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2024/02/23.
//

import UIKit

// MARK: - DiaryViewControllerFactory

final class DiaryViewControllerFactory {
    
    let diaryViewFactory: DiaryViewFactory
    let viewModel: DiaryViewModel
    
    init(diaryViewFactory: DiaryViewFactory, viewModel: DiaryViewModel) {
        self.diaryViewFactory = diaryViewFactory
        self.viewModel = viewModel
    }
}

// MARK: - Extensions

extension DiaryViewControllerFactory {
    func makeForeignDiaryViewController() -> ForeignDiaryViewController {
        let foreignDiaryView = diaryViewFactory.createForeginDiaryView()
        return ForeignDiaryViewController(rootView: foreignDiaryView, viewModel: viewModel)
    }
    
    func makeStepOneKoreanDiaryViewController() -> StepOneKoreanDiaryViewController {
        let stepOneKoreanDiaryView = diaryViewFactory.createStepOneKoreanDiaryView()
        return StepOneKoreanDiaryViewController(rootView: stepOneKoreanDiaryView, viewModel: viewModel)
    }
    
    func makeStepTwoKoreanDiaryViewController() -> StepTwoKoreanDiaryViewController {
        let stepTwoKoreanDiaryView = diaryViewFactory.createStepTwoKoreanDiaryView()
        return StepTwoKoreanDiaryViewController(rootView: stepTwoKoreanDiaryView, viewModel: viewModel)
    }
}
