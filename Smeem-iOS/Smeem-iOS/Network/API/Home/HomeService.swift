//
//  HomeService.swift
//  Smeem-iOS
//
//  Created by 임주민 on 2023/06/26.
//

import Foundation

import Moya

enum HomeService {
    case HomeDiary(startDate: String, endDate: String)
    case visit
}

extension HomeService: BaseTargetType {
    var path: String {
        switch self {
        case .HomeDiary:
            return URLConstant.diaryURL
        case .visit:
            return URLConstant.visitURL
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .HomeDiary:
            return .get
        case .visit:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .HomeDiary(let startDate, let endDate):
            return .requestParameters(parameters: ["start": startDate,
                                                   "end": endDate],
                                      encoding: URLEncoding.queryString)
        case .visit:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json",
                "Authorization": "Bearer " + UserDefaultsManager.accessToken]
    }
}
