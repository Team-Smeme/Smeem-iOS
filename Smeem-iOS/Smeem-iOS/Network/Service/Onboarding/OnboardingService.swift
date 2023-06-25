//
//  OnboardingService.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/06/23.
//

import Foundation
import Moya

enum OnboardingService {
    case userPlan(param: UserPlanRequest)
    case nickname(param: NicknameRequest)
}

extension OnboardingService: BaseTargetType {
    var path: String {
        switch self {
        case .userPlan:
            return "/members/plan"
        case .nickname:
            return "/members"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .userPlan, .nickname:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .userPlan(let param):
            return .requestJSONEncodable(param)
        case .nickname(let param):
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String : String]? {
        return NetworkConstant.tempTokenHeader
    }
}
