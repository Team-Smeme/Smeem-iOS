//
//  OnboardingModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/06/21.
//

import Foundation

struct OnboardingModel: Codable {
    let target: String
    let trainingTime: TrainingTime
    let hasAlarm: Bool
}

struct TrainingTime: Codable {
    let day, hour, minute: String
}
