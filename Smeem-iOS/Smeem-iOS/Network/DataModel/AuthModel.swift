//
//  AuthModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/06/25.
//

import Foundation

// MARK: - Login

struct LoginRequest: Codable {
    let social: String
    let fcmToken: String
}

struct LoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let isRegistered: Bool
    let hasPlan: Bool
}

extension LoginResponse {
    static let empty = LoginResponse(accessToken: "", refreshToken: "", isRegistered: false, hasPlan: false)
}

// MARK - ReLogin

struct ReLoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
}
