//
//  MyPageManagerImpl.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/25.
//

import Foundation

protocol MyPageManagerProtocol {
    func getMypage() async throws -> MyPageResponse
    func getBadgeList() async throws -> [BadgesListArray]
}

struct MyPageManager: MyPageManagerProtocol {

    private let myPageService: MyPageServiceProtocol
    
    init(myPageService: MyPageServiceProtocol) {
        self.myPageService = myPageService
    }
    
    func getMypage() async throws -> MyPageResponse {
        guard let response = try await myPageService.getMyPage()?.data else { return MyPageResponse.empty }
        return response
    }
    
    func getBadgeList() async throws -> [BadgesListArray] {
        guard let response = try await myPageService.getBadgeList()?.data?.badges else { return BadgesListArray.empty }
        return response
    }
}
