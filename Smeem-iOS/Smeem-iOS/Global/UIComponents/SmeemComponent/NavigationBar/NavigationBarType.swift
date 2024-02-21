//
//  NavigationBarType.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/09/09.
//

import Foundation

enum NavigationBarType {
    case diaryEnglish
    case diaryStepOne
    case diaryStepTwo
    case detail
    case edit
    case comment
    case myPage
    
    var layout: NavigationBarLayout {
        switch self {
        case .diaryEnglish:
            return .diaryLayout
        case .diaryStepOne:
            return .diaryLayout
        case .diaryStepTwo:
            return .detailLayout
        case .detail:
            return .detailLayout
        case .edit:
            return .editLayout
        case .comment:
            return .commentLayout
        case .myPage:
            return .detailLayout
        }
    }
}
