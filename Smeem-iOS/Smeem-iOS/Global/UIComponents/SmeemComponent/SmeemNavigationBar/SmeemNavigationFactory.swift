//
//  SmeemNavigationFactory.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/09/09.
//

import Foundation

class SmeemNavigationFactory {
    static func create(type: NavigationBarType) -> BaseNavigationBar {
        let navigationBar = BaseNavigationBar()
        var configurationBuilder = NavigationBarConfiguration.builder().storeLayout(type.layout)
        
        switch type {
        case .diaryEnglish:
            let configuration = configurationBuilder
                .storeLeftButtonTitle("취소")
                .storeTitle("English")
                .storeRightButtonTitle("완료")
                .storeLayout(type.layout)
                .build()
            navigationBar.applyConfiguraton(configuration)
            return navigationBar
        case .diaryStepOne:
            let configuration = configurationBuilder
                .storeLeftButtonTitle("취소")
                .storeTitle("한국어")
                .storeStepLabelTitle("STEP 1")
                .storeRightButtonTitle("완료")
                .storeLayout(type.layout)
            return navigationBar
        case .diaryStepTwo:
            let configuration = configurationBuilder
                .storeLeftButtonImage(Constant.Image.icnBack)
                .storeTitle("English")
                .storeStepLabelTitle("STEP 2")
                .storeRightButtonTitle("완료")
                .storeLayout(type.layout)
                .build()
            navigationBar.applyConfiguraton(configuration)
            return navigationBar
        case .detail:
            let configuration = configurationBuilder
                .storeLeftButtonImage(Constant.Image.icnBack)
                .storeRightButtonTitle("완료")
                .storeLayout(.detail)
                .storeLayout(type.layout)
                .build()
            navigationBar.applyConfiguraton(configuration)
            return navigationBar
        case .edit:
            let configuration = configurationBuilder
                .storeLeftButtonTitle("취소")
                .storeTitle("첨삭하기")
                .storeRightButtonTitle("완료")
                .storeLayout(type.layout)
                .build()
            navigationBar.applyConfiguraton(configuration)
            return navigationBar
        case .comment:
            let configuration = configurationBuilder
                .storeLeftButtonTitle("취소")
                .storeTitle("첨삭하기")
                .storeRightButtonTitle("완료")
                .storeLayout(type.layout)
                .build()
            navigationBar.applyConfiguraton(configuration)
            return navigationBar
        case .myPage:
            let configuration = configurationBuilder
                .storeLeftButtonImage(Constant.Image.icnBack)
                .storeTitle("마이페이지")
                .storeRightButtonImage(Constant.Image.icnMore)
                .storeLayout(type.layout)
                .build()
            navigationBar.applyConfiguraton(configuration)
            return navigationBar
        }
    }
}
