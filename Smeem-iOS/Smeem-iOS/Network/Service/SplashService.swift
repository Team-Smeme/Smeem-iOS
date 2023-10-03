//
//  SplashService.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/24.
//

import Foundation

protocol SplashServiceProtocol {
    func relogin() async throws -> BaseResponse<ReLoginResponse>?
    func logout() async throws -> BaseResponse<String>?
}

struct SplashService: SplashServiceProtocol {
    
    private let requestable: Requestable
    
    init(requestable: Requestable) {
        self.requestable = requestable
    }
    
    func relogin() async throws -> BaseResponse<ReLoginResponse>? {
        let urlRequest = SplashEndPoint.reLogin.makeUrlRequest()
        return try await requestable.request(urlRequest)
    }
    
    func logout() async throws -> BaseResponse<String>? {
        let urlRequest = SplashEndPoint.logout.makeUrlRequest()
        return try await requestable.request(urlRequest)
    }
}
