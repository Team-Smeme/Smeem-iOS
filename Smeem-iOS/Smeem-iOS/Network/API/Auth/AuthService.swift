//
//  AuthService.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/06/25.
//

import Foundation
import Moya

enum AuthService {
    case login(param: LoginRequest)
}

extension AuthService: BaseTargetType {
    var path: String {
        return URLConstant.loginURL
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Moya.Task {
        switch self {
        case .login(let param):
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String : String]? {
        return NetworkConstant.hasSocialTokenHeader
    }
}
