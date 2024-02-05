//
//  TrainingGoalResponse.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/07/01.
//

import Foundation

struct TrainingGoalResponse: Codable {
    let goals: [Goal]
}

struct Goal: Codable {
    let goalType, name: String
}
