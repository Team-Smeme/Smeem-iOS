//
//  PapagoService.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/26.
//

import Foundation

import Moya

enum PapagoService {
    case papago(param: String)
}

extension PapagoService: TargetType {
    var baseURL: URL {
        switch self {
        case .papago:
            return URL(string: URLConstant.papagoBaseURL)!
        }
    }
    
    var path: String {
        switch self {
        case .papago:
            return URLConstant.papagoPathURL
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .papago:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .papago(let param):
            return .requestParameters(parameters: ["source": "ko", "target": "en", "text": param], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return NetworkConstant.papagoHeader
    }
}
