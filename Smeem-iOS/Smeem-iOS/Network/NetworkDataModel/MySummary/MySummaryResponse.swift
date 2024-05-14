//
//  MySummaryResponse.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 4/27/24.
//

import Foundation

struct MySummaryResponse: Codable {
    let visitDays: Int
    let diaryCount: Int
    let diaryComboCount: Int
    let badgeCount: Int
}
