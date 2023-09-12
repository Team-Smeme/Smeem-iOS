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
            return .diary
        case .diaryStepOne:
            return .diary
        case .diaryStepTwo:
            return .diary
        case .detail:
            return .detail
        case .edit:
            return .edit
        case .comment:
            return .comment
        case .myPage:
            return .detail
        }
    }
}
