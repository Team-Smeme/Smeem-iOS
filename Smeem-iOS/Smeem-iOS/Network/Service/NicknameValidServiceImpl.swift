//
//  NicknameValidServiceImpl.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/27.
//

import Foundation

protocol NicknameValidService {
    func nicknameValid(param: String) async throws -> BaseResponse<NicknameValidResponse>?
}

struct NicknameValidServiceImpl: NicknameValidService {

    private let requestable: Requestable
    
    init(requestable: Requestable) {
        self.requestable = requestable
    }
    
    func nicknameValid(param: String) async throws -> BaseResponse<NicknameValidResponse>? {
        let urlRequest = NicknameValidEndPoint.nicknameValid(param: param).makeUrlRequest()
        return try await requestable.request(urlRequest)
    }
}
