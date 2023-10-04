//
//  DiaryViewBuilder.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/10/03.
//

struct DiaryViewConfiguration {
    var navigationBarType: NavigationBarType
    var textViewType: SmeemTextViewType
    var placeholderText: String
    var bottomViewType: DiaryBottomViewType
    var layoutConfig: StepTwoKoreanLayoutConfig?
}

class DiaryViewConfigurationBuilder {
    
    // TODO: 기본 설정값 만들기
    
    private var navigationBarType: NavigationBarType = .diaryEnglish
    private var textViewType: SmeemTextViewType = .display
    private var placeholderText: String = ""
    private var bottomViewType: DiaryBottomViewType = .standard
    private var layoutConfig: StepTwoKoreanLayoutConfig?
    
    func setNavigationBar(navigationBarType: NavigationBarType) -> Self {
        self.navigationBarType = navigationBarType
        return self
    }
    
    func setTextViewType(textViewType: SmeemTextViewType) -> Self {
        self.textViewType = textViewType
        return self
    }
    
    func setPlaceholderText(placeholderText: String) -> Self {
        self.placeholderText = placeholderText
        return self
    }
    
    func setBottomViewType(bottomViewType: DiaryBottomViewType) -> Self {
        self.bottomViewType = bottomViewType
        return self
    }
    
    func setLayoutConfig(layoutConfig: StepTwoKoreanLayoutConfig) -> Self {
        self.layoutConfig = layoutConfig
        return self
    }
    
    func build() -> DiaryViewConfiguration {
        return DiaryViewConfiguration(
            navigationBarType: navigationBarType,
            textViewType: textViewType,
            placeholderText: placeholderText,
            bottomViewType: bottomViewType,
            layoutConfig: layoutConfig
        )
    }
}
