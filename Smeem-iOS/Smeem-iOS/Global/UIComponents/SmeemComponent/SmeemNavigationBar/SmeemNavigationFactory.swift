//
//  SmeemNavigationFactory.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/09/09.
//

import Foundation

class SmeemNavigationFactory {
    static func create(type: NavigationBarType) -> Navigatable {
        let navigationBar: BaseNavigationBar
        var configuration: NavigationBarConfiguration
        
        switch type {
        case .diaryEnglish:
            navigationBar = BaseNavigationBar()
            configuration = NavigationBarConfiguration.builder()
                .storeLeftButtonTitle("취소")
                .storeTitle("English")
                .storeRightButtonTitle("완료")
                .build()
            navigationBar.applyConfiguraton(configuration)
            return navigationBar
        case .diaryStepOne:
            navigationBar = BaseNavigationBar()
            configuration = NavigationBarConfiguration.builder()
                .storeLeftButtonTitle("취소")
                .storeTitle("한국어")
                .storeStepLabelTitle("STEP 1")
                .storeRightButtonTitle("완료")
                .build()
            navigationBar.applyConfiguraton(configuration)
            return navigationBar
        case .diaryStepTwo:
            navigationBar = BaseNavigationBar()
            configuration = NavigationBarConfiguration.builder()
                .storeLeftButtonImage(Constant.Image.icnBack)
                .storeTitle("English")
                .storeStepLabelTitle("STEP 2")
                .storeRightButtonTitle("완료")
                .build()
            navigationBar.applyConfiguraton(configuration)
            return navigationBar
        case .detail:
            navigationBar = BaseNavigationBar()
            configuration = NavigationBarConfiguration.builder()
                .storeLeftButtonImage(Constant.Image.icnBack)
                .storeRightButtonTitle("완료")
                .build()
            navigationBar.applyConfiguraton(configuration)
            return navigationBar
        case .edit:
            navigationBar = BaseNavigationBar()
            configuration = NavigationBarConfiguration.builder()
                .storeLeftButtonTitle("취소")
                .storeTitle("첨삭하기")
                .storeRightButtonTitle("완료")
                .build()
            navigationBar.applyConfiguraton(configuration)
            return navigationBar
        case .comment:
            navigationBar = BaseNavigationBar()
            configuration = NavigationBarConfiguration.builder()
                .storeLeftButtonTitle("취소")
                .storeTitle("첨삭하기")
                .storeRightButtonTitle("완료")
                .build()
            navigationBar.applyConfiguraton(configuration)
            return navigationBar
        case .myPage:
            navigationBar = BaseNavigationBar()
            configuration = NavigationBarConfiguration.builder()
                .storeLeftButtonImage(Constant.Image.icnBack)
                .storeTitle("마이페이지")
                .storeRightButtonImage(Constant.Image.icnMore)
                .build()
            navigationBar.applyConfiguraton(configuration)
            return navigationBar
        }
    }
}
