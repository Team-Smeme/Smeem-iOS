//
//  MySummaryEndPoint.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 4/27/24.
//

import Foundation
import Moya

enum MySummaryEndPoint {
    case mySummary
    case myPlan
    case myBadge
}

extension MySummaryEndPoint: BaseTargetType {
    var path: String {
        switch self {
        case .mySummary:
            return URLConstant.mySummaryURL
        case .myPlan:
            return URLConstant.myPlanURL
        case .myBadge:
            return URLConstant.myPageURL
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .mySummary, .myPlan, .myBadge:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .mySummary, .myPlan, .myBadge:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json",
                "Authorization": "Bearer " + UserDefaultsManager.accessToken]
    }
}
