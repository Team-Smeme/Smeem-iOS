//
//  RandomSubjectAPI.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/21.
//

import Moya
import Foundation

enum RandomSubjectService {
    case randomSubject
}

extension RandomSubjectService: BaseTargetType {
    var path: String {
        switch self {
        case .randomSubject:
            return URLConstant.randomSubjectURL
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .randomSubject:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .randomSubject:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return NetworkConstant.tempTokenHeader
    }
}
