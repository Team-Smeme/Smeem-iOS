//
//  SplashEndPoint.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/24.
//

import Foundation

enum SplashEndPoint {
    case reLogin
    case logout
}

extension SplashEndPoint: BaseEndPoint {
    var path: String {
        switch self {
        case .reLogin:
            return URLConstant.reLoginURL
        case .logout:
            return URLConstant.logoutURL
        }
    }
    
    var httpMethod: HttpMethod {
        switch self {
        case .reLogin, .logout:
            return .post
        }
    }
    
    var query: [String : String]? {
        switch self {
        case .reLogin, .logout:
            return nil
        }
    }
    
    var requestBody: Data? {
        switch self {
        case .reLogin, .logout:
            return nil
        }
    }
    
    var header: [String : String] {
        switch self {
        case .logout:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer " + UserDefaultsManager.accessToken]
        case .reLogin:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer " + UserDefaultsManager.refreshToken]
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
