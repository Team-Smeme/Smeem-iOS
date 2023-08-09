//
//  AuthModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/06/25.
//

import Foundation

struct LoginRequest: Codable {
    let social: String
    let fcmToken: String
}

struct LoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let isRegistered: Bool
    let hasPlan: Bool
    let badges: [Badges]
}

struct Badges: Codable {
    let id: Int
    let name: String
    let type: String
    let imageUrl: String
}

struct ReLoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
}
