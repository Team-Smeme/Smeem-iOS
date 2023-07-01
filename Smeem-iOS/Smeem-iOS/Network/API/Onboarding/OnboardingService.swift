//
//  OnboardingService.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/06/23.
//

import Foundation
import Moya

enum OnboardingService {
    case planList
    case detailPlanList(param: String)
    case userPlan(param: UserPlanRequest)
    case nickname(param: NicknameRequest)
}

extension OnboardingService: BaseTargetType {
    var path: String {
        switch self {
        case .planList:
            return URLConstant.planListURL
        case .detailPlanList(let type):
            return URLConstant.planListURL+"/\(type)"
        case .userPlan:
            return URLConstant.userPlanURL
        case .nickname:
            return URLConstant.userURL
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .planList, .detailPlanList:
            return .get
        case .userPlan, .nickname:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .planList, .detailPlanList:
            return .requestPlain
        case .userPlan(let param):
            return .requestJSONEncodable(param)
        case .nickname(let param):
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .planList, .detailPlanList:
            return NetworkConstant.noTokenHeader
        case .userPlan, .nickname:
            return NetworkConstant.tempTokenHeader
        }
    }
}
