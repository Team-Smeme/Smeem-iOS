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
    case onboardingUserPlan(param: UserPlanRequest, token: String)
    case serviceAccept(param: ServiceAcceptRequest, token: String)
    case checkNickname(param: String, token: String)
}

extension OnboardingService: BaseTargetType {
    var path: String {
        switch self {
        case .planList:
            return URLConstant.planListURL
        case .detailPlanList(let type):
            return URLConstant.planListURL+"/\(type)"
        case .onboardingUserPlan:
            return URLConstant.userPlanURL
        case .serviceAccept:
            return URLConstant.userURL
        case .checkNickname:
            return URLConstant.checkNickname
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .planList, .detailPlanList, .checkNickname:
            return .get
        case .onboardingUserPlan, .serviceAccept:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .planList, .detailPlanList:
            return .requestPlain
        case .onboardingUserPlan(let param, _):
            return .requestJSONEncodable(param)
        case .serviceAccept(let param, _):
            return .requestJSONEncodable(param)
        case .checkNickname(let param, _):
            return .requestParameters(parameters: ["name": param], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .planList, .detailPlanList:
            return NetworkHeader.noTokenHeader
        case .onboardingUserPlan(_, let token), .serviceAccept(_, let token), .checkNickname(_, let token):
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer " + token]
        }
    }
}
