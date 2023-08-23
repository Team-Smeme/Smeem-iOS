//
//  MyPageService.swift
//  Smeem-iOS
//
//  Created by 임주민 on 2023/06/28.
//

import Foundation

import Moya

enum MyPageService {
    case myPageInfo
    case editNickname(param: EditNicknameRequest)
    case badgeList
    case myPageUserPlan(param: UserPlanRequest)
    case editAlarmTime(param: EditAlarmTime)
    case editPush(param: editPushRequest)
    case editGoal(param: EditGoalRequest)
}

extension MyPageService: BaseTargetType {
    var path: String {
        switch self {
        case .myPageInfo:
            return URLConstant.myPageURL
        case .editNickname:
            return URLConstant.userURL
        case .badgeList:
            return URLConstant.badgesListURL
        case .myPageUserPlan, .editGoal:
            return URLConstant.userPlanURL
        case .editAlarmTime:
            return URLConstant.userPlanURL
        case .editPush:
            return URLConstant.pushURL
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .myPageInfo, .badgeList:
            return .get
        case .editNickname, .myPageUserPlan, .editAlarmTime, .editPush, .editGoal:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .myPageInfo, .badgeList:
            return .requestPlain
        case .editNickname(let param):
            return .requestJSONEncodable(param)
        case .editGoal(param: let param):
            return .requestJSONEncodable(param)
        case .myPageUserPlan(let param):
            return .requestJSONEncodable(param)
        case .editAlarmTime(let param):
            return .requestJSONEncodable(param)
        case .editPush(let param):
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .myPageInfo, .editNickname, .badgeList, .myPageUserPlan, .editAlarmTime, .editPush, .editGoal:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer " + UserDefaultsManager.accessToken]
        }
    }
}

