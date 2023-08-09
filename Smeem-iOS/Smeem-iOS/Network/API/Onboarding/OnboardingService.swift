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
    case serviceAccept(param: ServiceAcceptRequest)
    case checkNickname(param: String)
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
        case .userPlan, .serviceAccept:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .planList, .detailPlanList:
            return .requestPlain
        case .userPlan(let param):
            return .requestJSONEncodable(param)
        case .serviceAccept(let param):
            return .requestJSONEncodable(param)
        case .checkNickname(let param):
            return .requestParameters(parameters: ["name": param], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .planList, .detailPlanList:
            return NetworkConstant.noTokenHeader
        case .userPlan, .serviceAccept, .checkNickname:
            return NetworkConstant.hasAccessTokenHeader
        }
    }
}
