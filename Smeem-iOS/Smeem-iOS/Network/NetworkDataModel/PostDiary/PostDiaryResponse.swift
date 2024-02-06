//
//  PostDiaryResponse.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/25.
//

import Foundation

// MARK: - PostDiaryResponse

struct PostDiaryResponse: Codable {
    let diaryID: Int
    let badges: [PopupBadge]

    enum CodingKeys: String, CodingKey {
        case diaryID = "diaryId"
        case badges
    }
}

// MARK: - Badge

struct PopupBadge: Codable {
    let name: String
    let imageUrl: String
    let type: String
}
