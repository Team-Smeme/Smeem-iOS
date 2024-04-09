//
//  DiaryViewControllerFactory.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2024/02/23.
//

import UIKit

// MARK: - DiaryViewControllerFactory

final class DiaryViewControllerFactory {
    
    private let diaryViewFactory: DiaryViewFactory
    
    init(diaryViewFactory: DiaryViewFactory) {
        self.diaryViewFactory = diaryViewFactory
    }
}

// MARK: - Extensions

extension DiaryViewControllerFactory {
    func makeForeignDiaryViewController() -> ForeignDiaryViewController {
        let viewModel = ForeignDiaryViewModel(model: DiaryModel())
        let foreignDiaryView = diaryViewFactory.createForeginDiaryView()
        return ForeignDiaryViewController(viewModel: viewModel)
    }
    
    func makeStepOneKoreanDiaryViewController() -> StepOneKoreanDiaryViewController {
        let viewModel = StepOneKoreanDiaryViewModel(model: DiaryModel())
        let stepOneKoreanDiaryView = diaryViewFactory.createStepOneKoreanDiaryView()
        return StepOneKoreanDiaryViewController(viewModel: viewModel)
    }
    
    func makeStepTwoKoreanDiaryViewController() -> StepTwoKoreanDiaryViewController {
        let viewModel = StepTwoKoreanDiaryViewModel(model: DiaryModel())
        let stepTwoKoreanDiaryView = diaryViewFactory.createStepTwoKoreanDiaryView()
        return StepTwoKoreanDiaryViewController(viewModel: viewModel)
    }
}
