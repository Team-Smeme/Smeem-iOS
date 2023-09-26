//
//  LoginEndPoint.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/24.
//

import Foundation

enum LoginEndPoint {
    case login(model: LoginRequest)
    case userPlan(model: UserPlanRequest, accessToken: String)
}

extension LoginEndPoint: BaseEndPoint {
    var path: String {
        switch self {
        case .login:
            return URLConstant.loginURL
        case .userPlan:
            return URLConstant.userPlanURL
        }
    }
    
    var httpMethod: HttpMethod {
        switch self {
        case .login:
            return .post
        case .userPlan:
            return .patch
        }
    }
    
    var query: [String : String]? {
        switch self {
        case .login, .userPlan:
            return nil
        }
    }
    
    var requestBody: Data? {
        switch self {
        case .login(let model):
            return try? model.dictionaryToData()
        case .userPlan(let model, _):
            return try? model.dictionaryToData()
        }
    }
    
    var header: [String : String] {
        switch self {
        case .login:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer " + UserDefaultsManager.socialToken]
        case .userPlan(_, let accessToken):
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer " + accessToken]
        }
    }
    
    func makeUrlRequest() -> NetworkRequest {
        return NetworkRequest(path: path,
                              httpMethod: httpMethod,
                              query: query,
                              body: requestBody,
                              headers: header)
    }
}
