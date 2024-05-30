//
//  File.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2/13/24.
//

import Foundation

enum AuthType: String {
    case signup
    case login
}

struct AuthModel {
    let accessToken: String
    let type: String
}

struct TrainingRequestModel {
    let plan: TrainingPlanRequest
    let accessToken: String
}
