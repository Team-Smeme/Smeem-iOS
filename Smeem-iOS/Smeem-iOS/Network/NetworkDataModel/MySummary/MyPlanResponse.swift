//
//  MyPlanResponse.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 4/28/24.
//

import Foundation

struct MyPlanResponse: Codable {
    let plan: String
    let goal: String
    let clearedCount: Int
    let clearCount: Int
}
