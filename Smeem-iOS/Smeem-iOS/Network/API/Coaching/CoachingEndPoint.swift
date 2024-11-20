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
