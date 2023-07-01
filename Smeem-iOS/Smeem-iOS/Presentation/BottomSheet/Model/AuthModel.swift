//
//  AuthModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/06/25.
//

import Foundation

struct BetaTestRequest: Codable {
    let fcmToken: String
}

struct BetaTestResponse: Codable {
    let accessToken: String
    let badges: [Badge]
}
