//
//  MyPlanAppData.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 5/1/24.
//

import Foundation

struct MyPlanAppData: Codable {
    let plan: String
    let goal: String
    let clearedCount: Int
    let clearCount: [Int]
}
