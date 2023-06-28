//
//  BadgeListModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/06/28.
//

import Foundation

// MARK: - Welcome

// MARK: - DataClass

struct BadgeListResponse: Codable {
    let badges: [BadgesListData]
}

// MARK: - Badge

struct BadgesListData: Codable {
    let id: Int
    let name, type: String
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, type
        case imageURL = "imageUrl"
    }
}
