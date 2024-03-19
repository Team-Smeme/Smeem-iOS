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
    case trainingUserPlan(param: TrainingPlanRequest, token: String)
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
        case .trainingUserPlan:
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
        case .trainingUserPlan, .serviceAccept:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .trainingGoal, .trainingWay:
            return .requestPlain
        case .trainingUserPlan(let param, _):
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
        case .trainingUserPlan(_, let token), .serviceAccept(_, let token), .checkNickname(_, let token):
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
                {
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
        case .trainingWay:
            return Data(
                """
                {
                    "success": true,
                    "message": "학습 목표 조회 성공",
                    "data": {
                        "name": "자기계발",
                        "way": "주 5회 이상 smeem 랜덤 주제로 일기 작성하기",
                        "detail": "사전 없이 일기 완성\nsmeem 연속 일기 배지 획득"
                    }
                }
                """.utf8
            )
        case .trainingUserPlan:
            
            return Data(
                """
                {
                    "success": true,
                    "message": "회원 학습 계획 업데이트 성공",
                    "data": null
                }
                """.utf8
            )
        case .serviceAccept:
            return Data(
                """
                {
                    "success": true,
                    "message": "닉네임 변경 성공",
                    "data": {
                        "badges": [
                            {
                                "name": "웰컴 배지",
                                "imageUrl": "https://github.com/Team-Smeme/Smeme-plan/assets/120551217/6b3319cb-4c6f-4bf2-86dd-7576a44b46c7",
                                "type": "EVENT"
                            }
                        ]
                    }
                }
                """.utf8
            )
        case .checkNickname:
            return Data(
                """
                {
                    "success": true,
                    "message": "닉네임 중복 검사 성공",
                    "data": {
                        "isExist": false
                    }
                }
                """.utf8
            )
        }
    }
}
