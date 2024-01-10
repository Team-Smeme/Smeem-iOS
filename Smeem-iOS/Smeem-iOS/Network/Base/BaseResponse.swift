//
//  BaseResponse.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/07.
//

import Foundation

struct BaseResponse<T: Decodable>: Decodable {
    let success: Bool
    let message: String
    let data: T?
}

/// status, message는 값이 있지만, data가 nil일 경우 사용합니다
struct NilType: Decodable {}

