//
//  MyPageAuthEndPoint.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/25.
//

import Foundation

enum MyPageAuthEndPoint {
    case resign
    case logout
}

extension MyPageAuthEndPoint: BaseEndPoint {
    
    var path: String {
        switch self {
        case .resign:
            return URLConstant.loginURL
        case .logout:
            return URLConstant.logoutURL
        }
    }
    
    var httpMethod: HttpMethod {
        switch self {
        case .resign:
            return .delete
        case .logout:
            return .post
        }
    }
    
    var query: [String : String]? {
        return nil
    }
    
    var requestBody: Data? {
        return nil
    }
    
    var header: [String : String] {
        return ["Content-Type": "application/json",
                "Authorization": "Bearer " + UserDefaultsManager.accessToken]
    }
    
    func makeUrlRequest() -> NetworkRequest {
        return NetworkRequest(path: path,
                              httpMethod: httpMethod,
                              headers: header)
    }
}
