//
//  MyPageInfoResponse.swift
//  Smeem-iOS
//
//  Created by 임주민 on 2023/06/28.
//

import Foundation

struct MyPageInfo: Codable {
    let username, target, way, detail: String
    let targetLang: String
    var hasPushAlarm: Bool
    let trainingTime: TrainingTime
    let badge: Badge
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

struct EditnicknameRequest: Codable {
    let username: String
}

struct EditAlarmTime: Codable {
    let trainingTime: TrainingTime
}

struct editPushRequest: Codable {
    let hasAlarm: Bool
}
