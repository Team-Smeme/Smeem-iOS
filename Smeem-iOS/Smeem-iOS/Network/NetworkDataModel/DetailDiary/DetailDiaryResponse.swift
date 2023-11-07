//
//  DetailDiaryResponse.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/25.
//

struct DetailDiaryResponse: Codable {
    let success: Bool
    let message: String
    let data: DetailDirayData
}

struct DetailDirayData: Codable {
    let diaryId: Int
    let topic: String
    let content: String
    let createdAt: String
    let username: String
    let corrections: [CorrentionsData]
}

struct CorrentionsData: Codable {
    let correntionId: Int
    let before: String
    let after: String
}
