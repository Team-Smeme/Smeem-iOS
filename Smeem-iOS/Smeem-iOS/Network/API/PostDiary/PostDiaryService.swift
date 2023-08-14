//
//  PostDiaryService.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/25.
//

import Moya

enum PostDiaryService {
    case postDiary(param: PostDiaryRequest)
    case patchDiary(param: PatchDiaryRequest, query: Int)
}

extension PostDiaryService: BaseTargetType {
    var path: String {
        switch self {
        case .postDiary:
            return URLConstant.diaryURL
        case .patchDiary(_, let query):
            return URLConstant.diaryURL+"/\(query)"
            
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postDiary:
            return .post
        case .patchDiary:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .postDiary(let param):
            return .requestJSONEncodable(param)
        case .patchDiary(let param, _):
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String : String]? {
        return NetworkConstant.hasAccessTokenHeader
    }
}
