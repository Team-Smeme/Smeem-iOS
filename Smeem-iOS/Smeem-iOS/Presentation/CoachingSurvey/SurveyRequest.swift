//
//  SurveyRequest.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 3/26/25.
//

import Foundation

struct SurveyRequest: Codable {
    let diaryId: Int
    let isSatisfied: Bool
    let dissatisfactionTypes: [String]
    let reason: String
}
