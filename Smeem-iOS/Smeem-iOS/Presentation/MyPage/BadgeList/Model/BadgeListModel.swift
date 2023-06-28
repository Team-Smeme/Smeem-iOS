//
//  BadgeListModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/06/28.
//

import Foundation

// MARK: - Welcome

// MARK: - DataClass

struct BadgeResponse: Codable {
    let badges: [BadgesData]
}

// MARK: - Badge
struct BadgesData: Codable {
    let id: Int
    let name, type: String
    let imageURL: String
}
