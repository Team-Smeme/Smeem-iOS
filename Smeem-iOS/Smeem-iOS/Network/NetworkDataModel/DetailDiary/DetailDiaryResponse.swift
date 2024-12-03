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
    let isUpdated: Bool // JSON 키에 맞게 수정
    var corrections: [CoachingResponse] // JSON 구조에 맞게 수정
    let correctionCount: Int
    let correctionMaxCount: Int

    static func == (lhs: DetailDiaryResponse, rhs: DetailDiaryResponse) -> Bool {
        return lhs.diaryId == rhs.diaryId
    }
}

//struct CorrentionsData: Codable {
//    let correntionId: Int
//    let before: String
//    let after: String
//}

extension DetailDiaryResponse {
    static let empty = DetailDiaryResponse(diaryId: 0, topic: "", content: "테스트임?", createdAt: "그래", username: "그래", isUpdated: true, corrections: [], correctionCount: 0, correctionMaxCount: 0)
}

//struct CoachingResponse: Codable, Equatable {
//    let originalSentence: String
//    let correctedSentence: String
//    let reason: String
//    let isCorrected: Bool
//
//    enum CodingKeys: String, CodingKey {
//        case originalSentence = "originalSentence"
//        case correctedSentence = "correctedSentence"
//        case reason
//        case isCorrected = "isCorrected"
//    }
//}
