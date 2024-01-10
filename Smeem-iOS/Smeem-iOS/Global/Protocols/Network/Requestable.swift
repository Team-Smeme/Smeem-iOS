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
        let (data, response) = try await URLSession.shared.data(for: request.makeUrlRequest())
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.typeCastingError
        }
        
        switch httpResponse.statusCode {
        case 400..<500:
            throw NetworkError.systemError
        case 500...:
            throw NetworkError.loadDataError
        default:
            break
        }

        let decoder = JSONDecoder()
        guard let decodeData = try? decoder.decode(BaseResponse<T>.self, from: data) else {
            throw NetworkError.jsonDecodingError
        }

        if decodeData.success == true {
            return decodeData
        } else {
            throw NetworkError.unknownError(message: decodeData.message)
        }
    }
}
