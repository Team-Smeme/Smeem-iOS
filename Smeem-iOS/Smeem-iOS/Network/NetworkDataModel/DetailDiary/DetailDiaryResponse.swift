//
//  DetailDiaryResponse.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/25.
//

struct DetailDiaryResponse: Codable, Equatable {
    let diaryId: Int
    let topic: String
    var content: String
    let createdAt: String
    let username: String
    let corrections: [CoachingResponse]
    let correctionCount: Int
    let correctionMaxCount: Int
}

struct CorrentionsData: Codable {
    let correntionId: Int
    let before: String
    let after: String
}

extension DetailDiaryResponse {
    static let empty = DetailDiaryResponse(diaryId: 0, topic: "", content: "", createdAt: "", username: "", corrections: [CoachingResponse(originalSentence: "", correctedSentence: "", reason: "", isCorrected: true)], correctionCount: 3, correctionMaxCount: 3)
}
