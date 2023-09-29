//
//  MyPageAuthManagerImpl.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/25.
//

import Foundation

protocol MyPageAuthManager {
    func deleteUserAccount() async throws
    func logout() async throws
}

struct MyPageAuthManagerImpl: MyPageAuthManager {

    private let myPageAuthService: MyPageAuthService
    
    init(myPageAuthService: MyPageAuthService) {
        self.myPageAuthService = myPageAuthService
    }
    
    func deleteUserAccount() async throws {
        guard let _ = try await myPageAuthService.resign() else { return }
    }
    
    func logout() async throws {
        guard let data = try await myPageAuthService.logout()?.data else { return }
        print(data)
    }
}

