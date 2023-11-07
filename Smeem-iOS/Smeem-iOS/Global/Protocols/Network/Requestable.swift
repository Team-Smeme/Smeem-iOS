//
//  Requestable.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/21.
//

import Foundation

protocol Requestable {
    func request<T: Decodable>(_ request: NetworkRequest) async throws -> BaseResponse<T>?
}

struct APIServie: Requestable {
    func request<T: Decodable>(_ request: NetworkRequest) async throws -> BaseResponse<T>? {
        let (data, _) = try await URLSession.shared.data(for: request.makeUrlRequest())
        let decoder = JSONDecoder()
        
        guard let decodeData = try? decoder.decode(BaseResponse<T>.self, from: data) else {
            throw NetworkError.jsonDecodingError
        }
        
        print(decodeData.message)
        
        if decodeData.success == true {
            return decodeData
        } else {
            throw NetworkError.clientError(message: decodeData.message)
        }
    }
}
