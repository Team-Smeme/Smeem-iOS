//
//  DiaryViewFactory.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/10/03.
//

import Foundation

class DiaryViewFactory {
    func createForeginDiaryView() -> DiaryView {
        let builder = DiaryViewConfigurationBuilder()
        let config = builder
            .setNavigationBar(navigationBarType: .diaryEnglish)
            .setTextViewType(textViewType: .editable(SmeemTextViewHandler()))
            .setPlaceholderText(placeholderText: "일기를 작성해주세요 :)")
            .setBottomViewType(bottomViewType: .standard)
            .build()
        
        return DiaryView(configuration: config)
    }
    
    func createStepOneKoreanDiaryView() -> DiaryView {
        let builder = DiaryViewConfigurationBuilder()
        let config = builder
            .setNavigationBar(navigationBarType: .diaryStepOne)
            .setTextViewType(textViewType: .editable(SmeemTextViewHandler()))
            .setPlaceholderText(placeholderText: "완벽한 문장으로 한국어 일기를 작성하면, 더욱 정확한 힌트를 받을 수 있어요.")
            .setBottomViewType(bottomViewType: .standard)
            .build()

        return DiaryView(configuration: config)
    }
    
    func createStepTwoKoreanDiaryView() -> DiaryView {
        let builder = DiaryViewConfigurationBuilder()
        let config = builder
            .setNavigationBar(navigationBarType: .diaryStepTwo)
            .setTextViewType(textViewType: .editable(SmeemTextViewHandler()))
            .setPlaceholderText(placeholderText: "일기를 작성해주세요 :)")
            .setBottomViewType(bottomViewType: .withHint)
            .setLayoutConfig(layoutConfig: StepTwoKoreanLayoutConfig())
            .build()
        
        return DiaryView(configuration: config)
    }
}
