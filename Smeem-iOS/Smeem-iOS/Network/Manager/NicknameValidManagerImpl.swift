//
//  NicknameValidManagerImpl.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/27.
//

import Foundation

protocol NicknameValidManager {
    func nicknameValid(param: String) async throws -> Bool
}

struct NicknameValidManagerImpl: NicknameValidManager {

    private let nicknameValidService: NicknameValidService
    
    init(nicknameValidService: NicknameValidService) {
        self.nicknameValidService = nicknameValidService
    }
    
    func nicknameValid(param: String) async throws -> Bool {
        guard let response = try await nicknameValidService.nicknameValid(param: param)?.data else { return false }
        return response.isExist
    }
}
