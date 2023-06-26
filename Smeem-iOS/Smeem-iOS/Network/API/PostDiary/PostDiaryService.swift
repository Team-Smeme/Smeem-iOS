//
//  PostDiaryService.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/25.
//

import Moya

enum PostDiaryService {
    case postDiary(param: PostDiaryRequest)
}

extension PostDiaryService: BaseTargetType {
    var path: String {
        switch self {
        case .postDiary:
            return URLConstant.diaryURL
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var task: Moya.Task {
        switch self {
        case .postDiary(let param):
            return .requestJSONEncodable(param)
        }
    }
    
    var headers: [String : String]? {
        return NetworkConstant.tempTokenHeader
    }
}
