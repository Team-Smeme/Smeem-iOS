//
//  PushTestService.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/07/05.
//

import Moya

enum PushTestService {
    case pushTest
}

extension PushTestService: BaseTargetType {
    var path: String {
        return URLConstant.pushTestURL
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json",
                "Authorization": "Bearer " + UserDefaultsManager.accessToken]
    }
}
