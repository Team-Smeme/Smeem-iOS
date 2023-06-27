//
//  HomeDiaryResponse.swift
//  Smeem-iOS
//
//  Created by 임주민 on 2023/06/26.
//

import Foundation

struct HomeDiaryResponse: Codable {
    let diaries: [HomeDiary]
}

struct HomeDiary: Codable {
    let diaryId: Int
    let content, createdAt: String
}

struct HomeDiaryCustom {
    let diaryId: Int
    let content, createdTime: String
}
