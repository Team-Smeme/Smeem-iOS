//
//  NicknameValidEndPoint.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/26.
//

import Foundation

enum NicknameValidEndPoint {
    case nicknameValid(param: String)
}

extension NicknameValidEndPoint: BaseEndPoint {
    var path: String {
        return URLConstant.checkNickname
    }
    
    var httpMethod: HttpMethod {
        return .get
    }
    
    var query: [String : String]? {
        switch self {
        case .nicknameValid(let param):
            return ["name":param]
        }
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
                              query: query,
                              headers: header)
    }    
}
