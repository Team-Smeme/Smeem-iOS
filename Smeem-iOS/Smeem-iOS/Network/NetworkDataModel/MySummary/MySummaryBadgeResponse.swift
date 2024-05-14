//
//  BadgeModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 5/6/24.
//

import Foundation

struct MySummaryBadgeArrayResponse: Codable {
    let badges: [MySummaryBadgeResponse]
}

struct MySummaryBadgeResponse: Codable {
    let badgeId: Int
    let name: String
    let type: String
    let hasBadge: Bool
    let remainingNumber: Int?
    let contentForNonBadgeOwner: String?
    let contentForBadgeOwner: String?
    let imageUrl: String
    let badgeAcquisitionRatio: Double
}
