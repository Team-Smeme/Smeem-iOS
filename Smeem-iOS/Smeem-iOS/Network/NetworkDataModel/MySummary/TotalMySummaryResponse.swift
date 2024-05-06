//
//  TotalMySummaryResponse.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 4/29/24.
//

import Foundation

struct TotalMySummaryResponse: Codable {
    let mySumamryText: [String]
    let mySummaryNumber: [Int]
    let myPlan: MyPlanAppData?
    let myBadge: [MySummaryBadgeResponse]
}
