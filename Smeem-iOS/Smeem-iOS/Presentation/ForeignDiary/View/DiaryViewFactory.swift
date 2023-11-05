//
//  DiaryViewFactory.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/10/03.
//

import Foundation

enum DiaryViewType {
    case foregin
    case stepOneKorean
    case stepTwoKorean
    case edit
}

class DiaryViewFactory {
    func createForeginDiaryView() -> DiaryView {
        let builder = DiaryViewConfigurationBuilder()
        let config = builder
            .setNavigationBar(navigationBarType: .diaryEnglish)
            .setTextViewType(textViewType: .editable(SmeemTextViewHandler.shared))
            .setPlaceholderText(placeholderText: "일기를 작성해주세요 :)")
            .setBottomViewType(bottomViewType: .standard)
            .build()
        
        return createDiaryView(with: config, viewType: .foregin)
    }
    
    func createStepOneKoreanDiaryView() -> DiaryView {
        let builder = DiaryViewConfigurationBuilder()
        let config = builder
            .setNavigationBar(navigationBarType: .diaryStepOne)
            .setTextViewType(textViewType: .editable(SmeemTextViewHandler.shared))
            .setPlaceholderText(placeholderText: "완벽한 문장으로 한국어 일기를 작성하면, 더욱 정확한 힌트를 받을 수 있어요.")
            .setBottomViewType(bottomViewType: .standard)
            .build()

        return createDiaryView(with: config, viewType: .stepOneKorean)
    }
    
    func createStepTwoKoreanDiaryView() -> DiaryView {
        let builder = DiaryViewConfigurationBuilder()
        let config = builder
            .setNavigationBar(navigationBarType: .diaryStepTwo)
            .setTextViewType(textViewType: .editable(SmeemTextViewHandler.shared))
            .setPlaceholderText(placeholderText: "일기를 작성해주세요 :)")
            .setBottomViewType(bottomViewType: .withHint)
            .setLayoutConfig(layoutConfig: StepTwoKoreanLayoutConfig())
            .build()
        
        return createDiaryView(with: config, viewType: .stepTwoKorean)
    }
    
    func createEditDiaryView() -> DiaryView {
        let builder = DiaryViewConfigurationBuilder()
        let config = builder
            .setNavigationBar(navigationBarType: .edit)
            .setTextViewType(textViewType: .editable(SmeemTextViewHandler.shared))
            .build()
        
        return createDiaryView(with: config, viewType: .edit)
    }
}

// MARK: - Helpers

extension DiaryViewFactory {
    private func createDiaryView(with configuration: DiaryViewConfiguration, viewType: DiaryViewType) -> DiaryView {
        let navigationBar = NavigationBarFactory.create(type: configuration.navigationBarType)
        let handler = SmeemTextViewHandler.shared
        handler.viewType = viewType
        
        let inputTextView = SmeemTextView(type: configuration.textViewType, placeholderText: configuration.placeholderText)
        let bottomView = DiaryBottomView(viewType: configuration.bottomViewType)
        let randomTopicView = RandomTopicView()
        
        return DiaryView(configuration: configuration, viewType: viewType, navigationBar: navigationBar, inputTextView: inputTextView, bottomView: bottomView, randomTopicView: randomTopicView)
    }
}
