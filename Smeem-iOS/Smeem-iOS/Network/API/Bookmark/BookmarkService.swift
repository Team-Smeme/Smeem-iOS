//
//  BookmarkService.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 8/15/25.
//

import Foundation
import Moya

final class BookmarkService: BookmarkServiceProtocol {
    
    static let shared = BookmarkService()
    private let bookmarkProvider = MoyaProvider<BookmarkEndPoint>(plugins: [MoyaLoggingPlugin()])
    
    func bookmarkGetAPI() async throws -> BookmarkModel {
        try await bookmarkProvider.request(.bookmarkGet)
    }
    
    func bookmarkPostAPI(request: BookmarkRequest) async throws -> BookmarkSuccess {
        try await bookmarkProvider.request(.bookmarkPost(request: request))
    }
    
    func deleteBookmarkAPI(bookmarkId: Int) async throws -> GeneralResponse<NilType> {
        try await bookmarkProvider.requestNilType(.deleteBookmark(bookmarkId: bookmarkId))
    }
    
    func bookmarkPatchAPI(request: BookmarkPatchRequest) async throws -> BookmarkPatchRequest {
        try await bookmarkProvider.request(.bookmarkPatch(request: request))
    }
    
    func bookmarkDetailAPI(bookmarkID: Int) async throws -> BookmarkDetailResponse {
        try await bookmarkProvider.request(.bookmarkDetail(bookmarkId: bookmarkID))
    }
}
