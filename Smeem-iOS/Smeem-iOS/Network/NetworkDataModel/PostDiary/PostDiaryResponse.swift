//
//  PostDiaryResponse.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/25.
//

import Foundation

// MARK: - PostDiaryResponse

struct PostDiaryResponse: Codable, Equatable {
    let diaryID: Int
    let badges: [PopupBadge]

    enum CodingKeys: String, CodingKey {
        case diaryID = "diaryId"
        case badges
    }
    
    static func == (lhs: PostDiaryResponse, rhs: PostDiaryResponse) -> Bool {
        return lhs.diaryID == rhs.diaryID
    }
}

extension PostDiaryResponse {
    static let empty = PostDiaryResponse(diaryID: 0, badges: [PopupBadge(name: "", imageUrl: "", type: "")])
}

// MARK: - Badge

struct PopupBadge: Codable {
    let name: String
    let imageUrl: String
    let type: String
}

extension PopupBadge {
    static let empty = [PopupBadge(name: "웰컴배지", imageUrl: "imageUrl", type: "EVENT")]
}
