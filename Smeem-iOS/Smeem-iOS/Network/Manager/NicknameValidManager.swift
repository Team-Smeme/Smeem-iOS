//
//  NicknameValidManagerImpl.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/27.
//

import Foundation

protocol NicknameValidManagerProtocol {
    func nicknameValid(param: String) async throws -> Bool
}

struct NicknameValidManager: NicknameValidManagerProtocol {

    private let nicknameValidService: NicknameValidServiceProtocol
    
    init(nicknameValidService: NicknameValidServiceProtocol) {
        self.nicknameValidService = nicknameValidService
    }
    
    func nicknameValid(param: String) async throws -> Bool {
        guard let response = try await nicknameValidService.nicknameValid(param: param)?.data else { return false }
        return response.isExist
    }
}
