//
//  OnboardingService.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/06/23.
//

import Foundation
import Moya

enum OnboardingService {
    case trainingGoal
    case trainingWay(param: String)
    case onboardingUserPlan(param: TrainingPlanRequest, token: String)
    case serviceAccept(param: ServiceAcceptRequest, token: String)
    case checkNickname(param: String, token: String)
}

extension OnboardingService: BaseTargetType {
    var path: String {
        switch self {
        case .trainingGoal:
            return URLConstant.trainingGoalsURL
        case .trainingWay(let type):
            return URLConstant.trainingGoalsURL+"/\(type)"
        case .onboardingUserPlan:
            return URLConstant.userTrainingInfo
        case .serviceAccept:
            return URLConstant.userURL
        case .checkNickname:
            return URLConstant.checkNickname
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .trainingGoal, .trainingWay, .checkNickname:
            return .get
        case .onboardingUserPlan, .serviceAccept:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .trainingGoal, .trainingWay:
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
        case .trainingGoal, .trainingWay:
            return ["Content-Type": "application/json",
                    "Authorization": ""]
        case .onboardingUserPlan(_, let token), .serviceAccept(_, let token), .checkNickname(_, let token):
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer " + token]
        }
    }
}
