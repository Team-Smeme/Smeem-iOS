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
}

extension CoachingEndPoint: BaseTargetType {
    var path: String {
        switch self {
        case .coaching(let diaryid):
            return URLConstant.diaryURL+"/\(diaryid)/corrections"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .coaching:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .coaching:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .coaching:
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
                                "original_sentence": "original text",
                                "corrected_sentence": "corrected text",
                                "reason": "수정된 문구입니다.",
                                "is_corrected": true
                            }
                        ]
                    }
                }
                """.utf8)
        }
    }
}
