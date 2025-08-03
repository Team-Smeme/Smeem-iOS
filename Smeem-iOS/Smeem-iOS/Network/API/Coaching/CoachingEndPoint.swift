//
//  CoachingEndPoint.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 11/17/24.
//

import Foundation
import Moya

enum CoachingEndPoint {
    case coaching(diaryId: Int)
    case survey(request: SurveyRequest)
}

extension CoachingEndPoint: BaseTargetType {
    var path: String {
        switch self {
        case .coaching(let diaryid):
            return URLConstant.diaryURL+"/\(diaryid)/corrections"
        case .survey:
            return URLConstant.survey
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .coaching, .survey:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .coaching:
            return .requestPlain
        case .survey(let request):
            return .requestJSONEncodable(request)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .coaching, .survey:
            return  ["Content-Type": "application/json",
                     "Authorization": "Bearer " + UserDefaultsManager.accessToken]
        }
    }
}

extension CoachingEndPoint {
    var sampleData: Data {
        switch self {
        case .coaching:
            return Data(
                """
                {
                    "success": true,
                    "message": "학습 코칭 성공",
                    "data": {
                        "corrections": [
                            {
                                "originalSentence": "original text",
                                "correctedSentence": "corrected text",
                                "reason": "수정된 문구입니다.",
                                "isCorrected": true
                            }
                        ]
                    }
                }
                """.utf8)
        case .survey:
            return Data()
        }
    }
}
