//
//  TrainingPlanResponse.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 5/1/24.
//

import Foundation

struct TrainingPlanResponse: Codable {
    let plans: [Plans]
}

struct Plans: Codable {
    let id: Int
    let content: String
}
