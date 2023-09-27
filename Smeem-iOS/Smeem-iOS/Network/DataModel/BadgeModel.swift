//
//  BadgeModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/06/28.
//

import Foundation

// MARK: - Badge Dummy

struct DummyModel {
    func dummyBadgeData() -> [[(String, String)]] {
        return [[("첫 번째 일기", Constant.Image.diaryCountingBadge1st), ("열 번째 일기", Constant.Image.diaryCountingBadge10th),
                 ("30번째 일기", Constant.Image.diaryCountingBadge30th), ("50번째 일기",Constant.Image.diaryCountingBadge50th)],
               [("3일 연속 일기", Constant.Image.diaryComboBadge3days), ("7일 연속 일기", Constant.Image.diaryComboBadge7days),
                ("15일 연속 일기", Constant.Image.diaryComboBadge15days), ("30일 연속 일기", Constant.Image.diaryComboBadge30days)],
               [("첫 번째 첨삭", Constant.Image.explorationBadge1st), ("3개 이상 첨삭", Constant.Image.explorationBadge3rd),
                ("5개 이상 첨삭", Constant.Image.explorationBadge5th), ("학습 목표 수정", Constant.Image.explorationBadgeGoodLuck)]]
    }
}

// MARK: BadgeListResponse (myPage)

struct BadgeListResponse: Codable {
    let badges: [BadgesListArray]
}

struct BadgesListArray: Codable {
    let id: Int
    let name, type: String
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, type
        case imageURL = "imageUrl"
    }
}

extension BadgesListArray {
    static let empty = [BadgesListArray(id: 0, name: "", type: "", imageURL: "")]
}

// MARK: Badges (onboarding, diary -> home)

struct Badges: Codable {
    let id: Int
    let name: String
    let type: String
    let imageUrl: String
}

// MARK: Badge (myPage)

struct Badge: Codable {
    let id: Int
    let name, type: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case id, name, type
        case imageURL = "imageUrl"
    }
}
