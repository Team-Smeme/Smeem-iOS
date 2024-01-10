//
//  PapagoResponse.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/25.
//

import Foundation

// MARK: - PapagoResponse

struct PapagoResponse: Codable {
    let message: Message
}

// MARK: - Message

struct Message: Codable {
    let result: Results
    let type, service, version: String
    
    enum CodingKeys: String, CodingKey {
        case result
        case type = "@type"
        case service = "@service"
        case version = "@version"
    }
}
// MARK: - Result

struct Results: Codable {
    let srcLangType, tarLangType, translatedText, engineType: String
    let pivot, dist, tarDict: JSONNull?
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
