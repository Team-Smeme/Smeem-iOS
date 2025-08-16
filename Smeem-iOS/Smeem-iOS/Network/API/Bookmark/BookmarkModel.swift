//
//  BookmarkModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 8/15/25.
//

import Foundation

struct Bookmarks: Codable, Identifiable {
    var id: Int { bookmarkId }
    let bookmarkId: Int
    let thumbnailImageUrl: String
    let expression: String
    let description: String
    let createdAt: String
    let scrapType: String?
}

struct BookmarkModel: Codable {
    let bookmarks: [Bookmarks]
}

struct BookmarkRequest: Codable {
    let url: String
}

struct BookmarkDetailResponse: Codable {
    let thumbnailImageUrl: String
    let scrapedUrl: String
    let expression: String
    let translatedExpression: String
    let description: String
    let scrapType: String
}

struct BookmarkSuccess: Codable {
    let scrapContent: ScrapContent
    let expression: String
    let translatedExpression: String
    let scrapedCountPerDay: Int
}

struct ScrapContent: Codable {
    let thumbnail: String
    let url: String
    let description: String
    let scrapType: String
}

struct BookmarkPatchRequest: Codable {
    let expression: String
    let translatedExpression: String
    let description: String
}
