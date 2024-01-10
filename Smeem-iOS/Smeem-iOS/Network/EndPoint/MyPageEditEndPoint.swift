//
//  MyPageEditEndPoint.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/26.
//

import Foundation

enum MyPageEditEndPoint {
    case editNickName(model: EditNicknameRequest)
    case editGoal(model: EditGoalRequest)
    case editPush(model: EditPushRequest)
    case editAlarmTime(model: EditAlarmTime)
}

extension MyPageEditEndPoint: BaseEndPoint {
    var path: String {
        switch self {
        case .editNickName:
            return URLConstant.userURL
        case .editGoal, .editAlarmTime:
            return URLConstant.userTrainingInfo
        case .editPush:
            return URLConstant.pushURL
        }
    }
    
    var httpMethod: HttpMethod {
        return .patch
    }
    
    var query: [String : String]? {
        return nil
    }
    
    var requestBody: Data? {
        switch self {
        case .editNickName(let model):
            return try? model.dictionaryToData()
        case .editGoal(let model):
            return try? model.dictionaryToData()
        case .editPush(let model):
            return try? model.dictionaryToData()
        case .editAlarmTime(let model):
            return try? model.dictionaryToData()
        }
    }
    
    var header: [String : String] {
        return ["Content-Type": "application/json",
                "Authorization": "Bearer " + UserDefaultsManager.accessToken]
    }
    
    func makeUrlRequest() -> NetworkRequest {
        return NetworkRequest(path: path,
                              httpMethod: httpMethod,
                              requestBody: requestBody,
                              headers: header)
    }
    
    
}
