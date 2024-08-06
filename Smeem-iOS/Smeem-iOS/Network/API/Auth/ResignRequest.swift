//
//  ResignRequest.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 7/30/24.
//

import Foundation

struct ResignRequest: Codable {
    let withdrawType: String
    let reason: String?
}
