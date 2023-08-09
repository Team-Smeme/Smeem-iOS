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
    case reLogin
}

extension AuthService: BaseTargetType {
    var path: String {
        switch self {
        case .login:
            return URLConstant.loginURL
        case .reLogin:
            return URLConstant.reLoginURL
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .reLogin:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .login(let param):
            return .requestJSONEncodable(param)
        case .reLogin:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login:
            return NetworkConstant.hasSocialTokenHeader
        case .reLogin:
            return NetworkConstant.hasRefreshTokenHeader
        }
    }
}
