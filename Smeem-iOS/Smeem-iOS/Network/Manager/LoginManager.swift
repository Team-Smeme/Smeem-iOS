//
//  LoginManager.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/24.
//

import Foundation

protocol LoginManagerProtocol {
    func login(model: LoginRequest) async throws -> LoginResponse
    func userPlan(model: UserTrainingInfoRequest, accessToken: String) async throws
}

struct LoginManager: LoginManagerProtocol {
    
    private let loginService: LoginServiceProtocol
    
    init(loginService: LoginServiceProtocol) {
        self.loginService = loginService
    }
    
    func login(model: LoginRequest) async throws -> LoginResponse {
        guard let response = try await loginService.login(model: model)?.data else { return LoginResponse.empty }
        return response
    }
    
    func userPlan(model: UserTrainingInfoRequest, accessToken: String) async throws {
        guard let _ = try await loginService.userPlan(model: model, accessToken: accessToken) else { return }
    }
}
