//
//  ServiceNetworkModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/06/21.
//

import Foundation

// MARK: - Nickname & serviceAccept

struct ServiceAcceptRequest: Codable {
    let username: String
    let termAccepted: Bool
}

struct ServiceAcceptResponse: Codable {
    let badges: [PopupBadge]
}
