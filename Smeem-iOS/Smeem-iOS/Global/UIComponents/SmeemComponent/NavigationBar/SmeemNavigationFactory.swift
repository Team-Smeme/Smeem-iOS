//
//  SmeemNavigationFactory.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/09/09.
//

import UIKit

class SmeemNavigationFactory {
    static func create(type: NavigationBarType) -> (BaseNavigationBar, NavigationBarActionDelegate?) {
        var actionDelegate: NavigationBarActionDelegate? = nil
        
        let navigationBar = BaseNavigationBar()
        var configurationBuilder = NavigationBarConfiguration.builder().withLayout(type.layout)
        
        switch type {
        case .diaryEnglish:
            let configuration = configurationBuilder
                .withLeftButtonTitle("취소")
                .withTitle("English")
                .withRightButtonTitle("완료")
                .withLayout(type.layout)
                .build()
            navigationBar.applyConfiguraton(configuration)
            return (navigationBar, actionDelegate)
        case .diaryStepOne:
            let configuration = configurationBuilder
                .withLeftButtonTitle("취소")
                .withTitle("한국어")
                .withStepLabelTitle("STEP 1")
                .withRightButtonTitle("완료")
                .withLayout(type.layout)
                .build()
            return (navigationBar, actionDelegate)
        case .diaryStepTwo:
            let configuration = configurationBuilder
                .withLeftButtonImage(Constant.Image.icnBack)
                .withTitle("English")
                .withStepLabelTitle("STEP 2")
                .withRightButtonTitle("완료")
                .withLayout(type.layout)
                .build()
            navigationBar.applyConfiguraton(configuration)
            return (navigationBar, actionDelegate)
        case .detail:
            let configuration = configurationBuilder
                .withLeftButtonImage(Constant.Image.icnBack)
                .withRightButtonImage(Constant.Image.icnMore)
                .withLayout(type.layout)
                .build()
            navigationBar.applyConfiguraton(configuration)
            navigationBar.actionDelegate = DetailDiaryViewController()
            return (navigationBar, actionDelegate)
        case .edit:
            let configuration = configurationBuilder
                .withLeftButtonTitle("취소")
                .withTitle("첨삭하기")
                .withRightButtonTitle("완료")
                .withLayout(type.layout)
                .build()
            navigationBar.applyConfiguraton(configuration)
            return (navigationBar, actionDelegate)
        case .comment:
            let configuration = configurationBuilder
                .withLeftButtonTitle("취소")
                .withTitle("첨삭하기")
                .withRightButtonTitle("완료")
                .withLayout(type.layout)
                .build()
            navigationBar.applyConfiguraton(configuration)
            return (navigationBar, actionDelegate)
        case .myPage:
            let configuration = configurationBuilder
                .withLeftButtonImage(Constant.Image.icnBack)
                .withTitle("마이페이지")
                .withRightButtonImage(Constant.Image.icnMore)
                .withLayout(type.layout)
                .build()
            navigationBar.applyConfiguraton(configuration)
            return (navigationBar, actionDelegate)
        }
    }
}
