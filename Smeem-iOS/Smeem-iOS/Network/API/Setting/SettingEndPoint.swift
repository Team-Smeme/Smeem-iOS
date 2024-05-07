//
//  SettingEndPoint.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 5/7/24.
//

import Foundation
import Moya

enum SettingEndPoint {
    case settingInfo
    case editPush(param: EditPushRequest)
}

extension SettingEndPoint: BaseTargetType {
    var path: String {
        switch self {
        case .settingInfo:
            return URLConstant.settingURL
        case .editPush:
            return URLConstant.pushURL
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .settingInfo:
            return .get
        case .editPush:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .settingInfo:
            return .requestPlain
        case .editPush(let param):
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json",
                "Authorization": "Bearer " + UserDefaultsManager.accessToken]
    }
}
