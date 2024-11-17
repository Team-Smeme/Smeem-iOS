//
//  DetailDiaryResponse.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/25.
//

struct DetailDiaryResponse: Codable {
    let diaryId: Int
    let topic: String
    let content: String
    let createdAt: String
    let username: String
}

struct CorrentionsData: Codable {
    let correntionId: Int
    let before: String
    let after: String
}

extension DetailDiaryResponse {
    static let empty = DetailDiaryResponse(diaryId: 0, topic: "", content: "", createdAt: "", username: "")
}
