//
//  GeneralResponse.swift
//  Smeme-iOS
//
//  Created by 황찬미 on 2023/05/02.
//

import Foundation

struct GeneralResponse<T: Decodable>: Decodable {
    let success: Bool
    let message: String
    let data: T?
}

struct GeneralArrayResponse<T: Decodable>: Decodable {
    let success: Bool
    let message: String
    let data: T?
}

/// status, message는 값이 있지만, data가 nil일 경우 사용합니다
struct NilType: Decodable {}

