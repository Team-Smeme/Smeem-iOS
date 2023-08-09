//
//  MyPageService.swift
//  Smeem-iOS
//
//  Created by 임주민 on 2023/06/28.
//

import Foundation

import Moya

enum MyPageService {
    case myPageInfo
    case changeMyNickName(param: NicknameRequest)
    case badgeList
}

extension MyPageService: BaseTargetType {
    var path: String {
        switch self {
        case .myPageInfo:
            return URLConstant.myPageURL
        case .changeMyNickName:
            return URLConstant.userURL
        case .badgeList:
            return URLConstant.badgesListURL
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .myPageInfo, .badgeList:
            return .get
        case .changeMyNickName:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .myPageInfo, .badgeList:
            return .requestPlain
        case .changeMyNickName(let param):
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .myPageInfo, .changeMyNickName, .badgeList:
            return NetworkConstant.hasAccessTokenHeader
        }
    }
}
