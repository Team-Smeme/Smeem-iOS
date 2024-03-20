//
//  UpdateResponse.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 3/20/24.
//

import Foundation

struct UpdateResponse: Codable {
    let title, content: String
    let iosVersion: iOSVersion
}

struct iOSVersion: Codable {
    let version, forceVersion: String
}

struct UpdateTextModel {
    let title, content: String
}
