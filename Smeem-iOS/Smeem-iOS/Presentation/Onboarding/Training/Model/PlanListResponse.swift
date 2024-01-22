//
//  PlanListResponse.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/07/01.
//

import Foundation

struct PlanListResponse: Codable {
    let goals: [Plan]
}

struct Plan: Codable {
    let goalType, name: String
}
