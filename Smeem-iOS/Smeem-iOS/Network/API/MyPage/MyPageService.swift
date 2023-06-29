//
//  MyPageService.swift
//  Smeem-iOS
//
//  Created by 임주민 on 2023/06/28.
//

import Foundation

import Moya

enum MyPageService {
    case MyPageInfo
    case ChangeMyNickName(param: NicknameRequest)
    case badgeList
}

extension MyPageService: BaseTargetType {
    var path: String {
        switch self {
        case .MyPageInfo:
            return URLConstant.myPageURL
        case .ChangeMyNickName:
            return URLConstant.userURL
        case .badgeList:
            return URLConstant.badgesListURL
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .MyPageInfo, .badgeList:
            return .get
        case .ChangeMyNickName:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .MyPageInfo, .badgeList:
            return .requestPlain
        case .ChangeMyNickName(let param):
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .MyPageInfo, .ChangeMyNickName, .badgeList:
            return NetworkConstant.tempTokenHeader
        }
    }
}
