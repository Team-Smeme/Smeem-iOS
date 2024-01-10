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
    case resign
    case logout
}

extension AuthService: BaseTargetType {
    var path: String {
        switch self {
        case .login, .resign:
            return URLConstant.loginURL
        case .reLogin:
            return URLConstant.reLoginURL
        case .logout:
            return URLConstant.logoutURL
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .reLogin, .logout:
            return .post
        case .resign:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .login(let param):
            return .requestJSONEncodable(param)
        case .reLogin, .resign, .logout:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer " + UserDefaultsManager.socialToken]
        case .resign, .logout:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer " + UserDefaultsManager.accessToken]
        case .reLogin:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer " + UserDefaultsManager.refreshToken]
        }
    }
}
