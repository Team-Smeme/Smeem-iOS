//
//  SplashEndPoint.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 3/20/24.
//

import Foundation
import Moya

enum SplashEndPoint {
    case update
}

extension SplashEndPoint: BaseTargetType {
    var path: String {
        return URLConstant.updateURL
    }

    var method: Moya.Method {
        return .get
    }

    var task: Moya.Task {
        return .requestPlain
    }

    var headers: [String : String]? {
        return .none
    }
}


