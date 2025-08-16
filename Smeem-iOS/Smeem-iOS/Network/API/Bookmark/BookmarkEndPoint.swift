//
//  BookmarkEndPoint.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 8/15/25.
//

import Foundation
import Moya

enum BookmarkEndPoint {
    case bookmarkGet
    case bookmarkPost(request: BookmarkRequest)
    case deleteBookmark(bookmarkId: Int)
    case bookmarkPatch(request: BookmarkPatchRequest)
    case bookmarkDetail(bookmarkId: Int)
}

extension BookmarkEndPoint: BaseTargetType {
    var path: String {
        switch self {
        case .bookmarkGet, .bookmarkPost:
            return URLConstant.bookmarks
        case .deleteBookmark(let id):
            return URLConstant.bookmarks + "/\(id)"
        case .bookmarkPatch(let id):
            return URLConstant.bookmarks + "/\(id)"
        case .bookmarkDetail(let id):
            return URLConstant.bookmarks + "/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .bookmarkGet, .bookmarkDetail:
            return .get
        case .bookmarkPost:
            return .post
        case .bookmarkPatch:
            return .patch
        case .deleteBookmark:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .bookmarkGet, .bookmarkDetail, .deleteBookmark:
            return .requestPlain
        case .bookmarkPost(let request):
            return .requestJSONEncodable(request)
        case .bookmarkPatch(let request):
            return .requestJSONEncodable(request)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .bookmarkGet, .bookmarkDetail, .deleteBookmark, .bookmarkPost, .bookmarkPatch:
            return  ["Content-Type": "application/json",
                     "Authorization": "Bearer " + UserDefaultsManager.accessToken]
        }
    }
}
