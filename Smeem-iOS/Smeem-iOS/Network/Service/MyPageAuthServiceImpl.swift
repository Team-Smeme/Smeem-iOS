//
//  MyPageAuthServiceImpl.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/25.
//

import Foundation

protocol MyPageAuthService {
    func resign() async throws -> BaseResponse<NilType>?
    func logout() async throws -> BaseResponse<NilType>?
}

struct MyPageAuthServiceImpl: MyPageAuthService {

    private let requestable: Requestable
    
    init(requestable: Requestable) {
        self.requestable = requestable
    }
    
    func resign() async throws -> BaseResponse<NilType>? {
        let urlRequest = MyPageEndPoint.getMyPage.makeUrlRequest()
        return try await requestable.request(urlRequest)
    }
    
    func logout() async throws -> BaseResponse<NilType>? {
        let urlRequest = MyPageEndPoint.getMyPage.makeUrlRequest()
        return try await requestable.request(urlRequest)
    }
}
