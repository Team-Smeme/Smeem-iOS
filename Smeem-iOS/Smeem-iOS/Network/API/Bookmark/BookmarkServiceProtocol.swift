//
//  BookmarkServiceProtocol.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 8/15/25.
//

import Foundation

protocol BookmarkServiceProtocol {
    func bookmarkGetAPI() async throws -> BookmarkModel
    func bookmarkPostAPI(request: BookmarkRequest) async throws -> BookmarkSuccess
    func deleteBookmarkAPI(bookmarkId: Int) async throws -> GeneralResponse<NilType>
    func bookmarkPatchAPI(request: BookmarkPatchRequest) async throws -> BookmarkPatchRequest
    func bookmarkDetailAPI(bookmarkID: Int) async throws -> BookmarkDetailResponse
}
