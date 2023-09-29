//
//  LoginServiceImple.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/24.
//

import Foundation

protocol LoginService {
    func login(model: LoginRequest) async throws -> BaseResponse<LoginResponse>?
    func userPlan(model: UserPlanRequest, accessToken: String) async throws -> BaseResponse<String>?
}

struct LoginServiceImpl: LoginService {
    
    private let requestable: Requestable
    
    init(requestable: Requestable) {
        self.requestable = requestable
    }
    
    func login(model: LoginRequest) async throws -> BaseResponse<LoginResponse>? {
        let urlRequest = LoginEndPoint.login(model: model).makeUrlRequest()
        return try await requestable.request(urlRequest)
    }
    
    func userPlan(model: UserPlanRequest, accessToken: String) async throws -> BaseResponse<String>? {
        let urlRequest = LoginEndPoint.userPlan(model: model, accessToken: accessToken).makeUrlRequest()
        return try await requestable.request(urlRequest)
    }
}
