//
//  OnboardingService.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/06/23.
//

import Foundation
import Moya

enum OnboardingEndPoint {
    case trainingGoal
    case trainingWay(param: String)
    case onboardingUserPlan(param: TrainingPlanRequest, token: String)
    case serviceAccept(param: ServiceAcceptRequest, token: String)
    case checkNickname(param: String, token: String)
}

extension OnboardingEndPoint: BaseTargetType {
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

extension OnboardingEndPoint {
    var sampleData: Data {
        switch self {
        case .trainingGoal:
            return Data(
                """
                    "success": true,
                    "message": "학습 목표 리스트 조회 성공",
                    "data": {
                        "goals": [
                            {
                                "goalType": "DEVELOP",
                                "name": "자기계발"
                            },
                            {
                                "goalType": "HOBBY",
                                "name": "취미로 즐기기"
                            },
                            {
                                "goalType": "APPLY",
                                "name": "현지 언어 체득"
                            },
                            {
                                "goalType": "BUSINESS",
                                "name": "유창한 비즈니스 영어"
                            },
                            {
                                "goalType": "EXAM",
                                "name": "어학 시험 고득점"
                            },
                            {
                                "goalType": "NONE",
                                "name": "아직 모르겠어요"
                            }
                        ]
                    }
                }
                """.utf8
                )
            
        case .onboardingUserPlan:
            
            return Data(
                """
                {
                    "success": true,
                    "message": "회원 학습 계획 업데이트 성공",
                    "data": null
                }
                """.utf8
            )
        default: break
        }
        
        return Data()
    }
}
