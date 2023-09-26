//
//  MyPageInfoResponse.swift
//  Smeem-iOS
//
//  Created by 임주민 on 2023/06/28.
//

import Foundation

struct MyPageResponse: Codable {
    let username, target, way, detail: String
    let targetLang: String
    var hasPushAlarm: Bool
    let trainingTime: TrainingTime
    let badge: Badge
}

extension MyPageResponse {
    static let empty = MyPageResponse(username: "", target: "", way: "", detail: "", targetLang: "", hasPushAlarm: false,
                                      trainingTime: TrainingTime(day: "", hour: 0, minute: 0),
                                      badge: Badge(id: 0, name: "", type: "", imageURL: ""))
}

struct Badge: Codable {
    let id: Int
    let name, type: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case id, name, type
        case imageURL = "imageUrl"
    }
}

struct EditNicknameRequest: Codable {
    let username: String
}

struct EditAlarmTime: Codable {
    let trainingTime: TrainingTime
}

struct EditPushRequest: Codable {
    let hasAlarm: Bool
}

struct EditGoalRequest: Codable {
    let target: String
}
