//
//  MyPageEndPoint.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/25.
//

import Foundation

enum MyPageEndPoint {
    case getMyPage
    case getBadgeList
}

extension MyPageEndPoint: BaseEndPoint {
    
    var path: String {
        switch self {
        case .getMyPage:
            return URLConstant.myPageURL
        case .getBadgeList:
            return URLConstant.badgesListURL
        }
    }
    
    var httpMethod: HttpMethod {
        switch self {
        case .getMyPage, .getBadgeList:
            return .get
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
