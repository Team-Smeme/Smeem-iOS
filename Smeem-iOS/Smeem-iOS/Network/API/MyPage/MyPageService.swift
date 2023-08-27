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
    case editNinkname(param: EditnicknameRequest)
    case badgeList
    case myPageUserPlan(param: UserPlanRequest)
}

extension MyPageService: BaseTargetType {
    var path: String {
        switch self {
        case .myPageInfo:
            return URLConstant.myPageURL
        case .editNinkname:
            return URLConstant.userURL
        case .badgeList:
            return URLConstant.badgesListURL
        case .myPageUserPlan:
            return URLConstant.userPlanURL
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .myPageInfo, .badgeList:
            return .get
        case .editNinkname, .myPageUserPlan:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .myPageInfo, .badgeList:
            return .requestPlain
        case .editNinkname(let param):
            return .requestJSONEncodable(param)
        case .myPageUserPlan(let param):
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .myPageInfo, .editNinkname, .badgeList, .myPageUserPlan:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer " + UserDefaultsManager.accessToken]
        }
    }
}
