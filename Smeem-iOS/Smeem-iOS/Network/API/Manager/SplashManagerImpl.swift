//
//  SplashManagerImpl.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/24.
//

import Foundation

protocol SplashManager {
    func relogin() async throws -> ReLoginResponse
    func logout() async throws
}

struct SplashManagerImpl: SplashManager {
    
    private let splashService: SplashService
    
    init(splashService: SplashService) {
        self.splashService = splashService
    }
    
    func relogin() async throws -> ReLoginResponse {
        guard let response = try await splashService.relogin() else { return ReLoginResponse(accessToken: "", refreshToken: "")}
        return response
    }
    
    func logout() async throws {
        guard let _ = try await splashService.logout() else { return }
    }
}
