//
//  SplashService.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/24.
//

import Foundation

protocol SplashService {
    func relogin() async throws -> ReLoginResponse?
    func logout() async throws -> String?
}

struct SplashServiceImpl: SplashService {
    
    private let requestable: Requestable
    
    init(requestable: Requestable) {
        self.requestable = requestable
    }
    
    func relogin() async throws -> ReLoginResponse? {
        let urlRequest = SplashEndPoint.reLogin.makeUrlRequest()
        return try await requestable.request(urlRequest)
    }
    
    func logout() async throws -> String? {
        let urlRequest = SplashEndPoint.logout.makeUrlRequest()
        return try await requestable.request(urlRequest)
    }
}
