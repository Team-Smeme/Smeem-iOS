//
//  MyPageServiceImpl.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/25.
//

import Foundation

protocol MyPageService {
    func getMyPage() async throws -> BaseResponse<MyPageResponse>?
    func getBadgeList() async throws -> BaseResponse<BadgeListResponse>?
}

struct MyPageServiceImpl: MyPageService {

    private let requestable: Requestable
    
    init(requestable: Requestable) {
        self.requestable = requestable
    }
    
    func getMyPage() async throws -> BaseResponse<MyPageResponse>? {
        let urlRequest = MyPageEndPoint.getMyPage.makeUrlRequest()
        return try await requestable.request(urlRequest)
    }
    
    func getBadgeList() async throws -> BaseResponse<BadgeListResponse>? {
        let urlRequest = MyPageEndPoint.getBadgeList.makeUrlRequest()
        return try await requestable.request(urlRequest)
    }
}
