//
//  Plan.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/27.
//

import Foundation

// MARK: Plan List

struct PlanListResponse: Codable {
    let goals: [GoalPlanResponse]
}

struct GoalPlanResponse: Codable {
    let goalType, name: String
}

// MARK: detail Plan List

struct DetailPlanListResponse:Codable {
    let name: String
    let way: String
    let detail: String
}
