//
//  SettingResponse.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 5/7/24.
//

import Foundation

struct SettingResponse: Codable {
    let username, target, title, way: String
    let detail, targetLang: String
    let hasPushAlarm: Bool
    let trainingTime: TrainingTime
    let badge: Badge?
    let trainingPlan: Plans?
}

struct PlanIdRequest: Codable {
    let planId: Int
}
