//
//  PostDiaryRequest.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/25.
//

struct PostDiaryRequest: Codable {
    let content: String
    let topicId: String?
}
