//
//  DiaryModel.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2024/02/24.
//

struct DiaryModel {
    var topicID: Int? = nil
    var topicContent: String?
    var diaryID: Int?
    var badgePopupContent: [PopupBadge]?
    var isTopicCalled: Bool = false
    var hintText: String?
}
