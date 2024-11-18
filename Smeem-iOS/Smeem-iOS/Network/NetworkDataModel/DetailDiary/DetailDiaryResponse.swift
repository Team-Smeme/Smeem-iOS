//
//  DetailDiaryResponse.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/25.
//

struct DetailDiaryResponse: Codable, Equatable {
    let diaryId: Int
    let topic: String
    let content: String
    let createdAt: String
    let username: String
    
    static func == (lhs: DetailDiaryResponse, rhs: DetailDiaryResponse) -> Bool {
        return lhs.diaryId == rhs.diaryId
    }
}

struct CorrentionsData: Codable {
    let correntionId: Int
    let before: String
    let after: String
}

extension DetailDiaryResponse {
    static let empty = DetailDiaryResponse(diaryId: 0, topic: "", content: "테스트임?", createdAt: "그래", username: "그래")
}
