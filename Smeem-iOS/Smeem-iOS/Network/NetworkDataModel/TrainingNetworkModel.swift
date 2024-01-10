//
//  TrainingNetworkModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/27.
//

import Foundation

// MARK: - Training goals array response

struct TrainingGoalsArrayResponse: Codable {
    let goals: [TrainingGoals]
}

struct TrainingGoals: Codable {
    let goalType, name: String
}

extension TrainingGoals {
    static let empty = TrainingGoals(goalType: "", name: "")
}

// MARK: - Training how response

struct TrainingHowResponse:Codable {
    let name: String
    let way: String
    let detail: String
}

extension TrainingHowResponse {
    static let empty = TrainingHowResponse(name: "", way: "", detail: "")
}

// MARK: - User training info request

struct UserTrainingInfoRequest: Codable {
    let target: String
    let trainingTime: TrainingTime
    let hasAlarm: Bool
}

struct TrainingTime: Codable {
    let day: String
    let hour, minute: Int
}
