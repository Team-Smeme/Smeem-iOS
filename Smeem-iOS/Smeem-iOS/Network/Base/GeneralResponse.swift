//
//  GeneralResponse.swift
//  Smeme-iOS
//
//  Created by 황찬미 on 2023/05/02.
//

import Foundation

struct GeneralResponse<T: Decodable>: Decodable {
    var success: Bool
    var message: String?
    var data: T?
    
    enum CodingKeys: String, CodingKey {
        case message
        case data
        case success
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        data = (try? values.decode(T.self, forKey: .data)) ?? nil
        success = (try? values.decode(Bool.self, forKey: .success)) ?? false
    }
}

struct GeneralArrayResponse<T: Decodable>: Decodable {
    let message: String?
    let success: Bool?
    let data: [T]?
    
    enum CodingKeys: String, CodingKey {
        case message
        case data
        case success
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        data = (try? values.decode([T].self, forKey: .data)) ?? []
        success = (try? values.decode(Bool.self, forKey: .success)) ?? false
    }
}

/// status, message, success 이외에 정보를 사용하지 않는 경우에 VoidType를 설정해주면 됩니다!
struct VoidType: Decodable {}

