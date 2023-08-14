//
//  DetailDiaryService.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/25.
//

import Moya

enum DetailDiaryService {
    case detailDiary(diaryID: Int)
    case deleteDiary(diaryID: Int)
}

extension DetailDiaryService: BaseTargetType {
    var path: String {
        switch self {
        case .detailDiary(let diaryID), .deleteDiary(let diaryID):
            return URLConstant.diaryURL + "/\(diaryID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .detailDiary:
            return .get
        case .deleteDiary:
            return .delete
        }
    }
    
    var task: Moya.Task {
       return .requestPlain
    }
    
    var headers: [String : String]? {
        return NetworkConstant.hasAccessTokenHeader
    }
}
