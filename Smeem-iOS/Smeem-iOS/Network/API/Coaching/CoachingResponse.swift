//
//  CoachingResponse.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 11/17/24.
//

import Foundation

struct CoachingsResponse: Codable {
    let corrections: [CoachingResponse]
}

struct CoachingResponse: Codable {
    let original_sentence: String
    let corrected_sentence: String
    let reason: String
    let is_corrected: Bool
}
