//
//  RandomSubjectResponse.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/22.
//

struct RandomSubjectResponse: Codable {
    let success: Bool
    let message: String
    let data: RandomSubjectData
}

struct RandomSubjectData: Codable {
    let topicId: Int
    let content: String
}
