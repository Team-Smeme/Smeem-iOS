//
//  LoginManagerImpl.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/24.
//

import Foundation

protocol LoginManager {
    func login(model: LoginRequest) async throws -> LoginResponse
    func userPlan(model: UserPlanRequest, accessToken: String) async throws
}

struct LoginManagerImpl: LoginManager {
    
    private let loginService: LoginService
    
    init(loginService: LoginService) {
        self.loginService = loginService
    }
    
    func login(model: LoginRequest) async throws -> LoginResponse {
        guard let response = try await loginService.login(model: model) else { return LoginResponse.empty }
        return response
    }
    
    func userPlan(model: UserPlanRequest, accessToken: String) async throws {
        guard let _ = try await loginService.userPlan(model: model, accessToken: accessToken) else { return }
    }
}
