//
//  OnboardingModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/06/21.
//

import Foundation

// MARK: - UserPlan & trainingTime

struct UserPlanRequest: Codable {
    let target: String
    let trainingTime: TrainingTime
    let hasAlarm: Bool
}

struct TrainingTime: Codable {
    let day: String
    let hour, minute: Int
}

// MARK: - Nickname & serviceAccept

struct ServiceAcceptRequest: Codable {
    let username: String
    let termAccepted: Bool
}

struct ServiceAcceptResponse: Codable {
    let badges: [PopupBadge]
}
