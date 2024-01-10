//
//  TrainingEndPoint.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/10/09.
//

import Foundation

enum TrainingEndPoint {
    case trainingGoal
    case trainingHow(query: String)
    case userTrainingInfo(model: UserTrainingInfoRequest)
}

extension TrainingEndPoint: BaseEndPoint {
    var path: String {
        switch self {
        case .trainingGoal:
            return URLConstant.trainingGoalsURL
        case .trainingHow(let query):
            return URLConstant.trainingGoalsURL + "/\(query)"
        case .userTrainingInfo:
            return URLConstant.userTrainingInfo
        }
    }
    
    var httpMethod: HttpMethod {
        switch self {
        case .trainingGoal, .trainingHow:
            return .get
        case .userTrainingInfo:
            return .patch
        }
    }
    
    var query: [String : String]? {
        return nil
    }
    
    var requestBody: Data? {
        switch self {
        case .trainingGoal, .trainingHow:
            return nil
        case .userTrainingInfo(let model):
            return try? model.dictionaryToData()
        }
    }
    
    var header: [String : String] {
        switch self {
        case .trainingGoal, .trainingHow:
            return ["Content-Type": "application/json",
                    "Authorization": ""]
        case .userTrainingInfo:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer " + UserDefaultsManager.clientAccessToken]
        }
    }
    
    func makeUrlRequest() -> NetworkRequest {
        return NetworkRequest(path: path,
                              httpMethod: httpMethod,
                              requestBody: requestBody,
                              headers: header)
    }
}
