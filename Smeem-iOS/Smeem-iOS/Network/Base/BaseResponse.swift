//
//  BaseResponse.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/07.
//

import Foundation

// 임의로 주석 처리
// typealias Request = Encodable
// typealias Response = Decodable

struct BaseResponse<T: Decodable>: Decodable {
    let success: Bool
    let message: String
    let data: T?
}

struct BaseArrayResponse< T: Decodable>: Decodable {
    let success: Bool
    let message: String
    let data: [T]?
}

