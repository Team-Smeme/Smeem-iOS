//
//  AuthService.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/06/25.
//

import Foundation
import Moya

enum AuthService {
    case beta(param: BetaTestRequest)
}

extension AuthService: TargetType {
    var baseURL: URL {
        return URL(string: SharedConstant.betaBaseURL)!
    }
    
    var path: String {
        return "api/beta/token"
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Moya.Task {
        switch self {
        case .beta(let param):
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String : String]? {
        return NetworkConstant.noTokenHeader
    }
}
