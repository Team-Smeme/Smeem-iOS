//
//  DeepLResponse.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2024/01/15.
//

import Foundation

// MARK: - DeeplResponse

struct DeepLResponse: Codable {
    let translations: [Translation]
}

// MARK: - Translation

struct Translation: Codable {
    let detectedSourceLanguage: String?
    let text: String
    
    enum CodingKeys: String, CodingKey {
        case detectedSourceLanguage = "detectedSourceLanguage"
        case text
    }
}
