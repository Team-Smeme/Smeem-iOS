//
//  MyPageNetworkModel.swift
//  Smeem-iOS
//
//  Created by 임주민 on 2023/06/28.
//

import Foundation

// MARK: - My Page Edit

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
