//
//  DetailDiaryService.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/25.
//

import Moya

enum DetailDiaryService {
    case detailDiary(diaryID:Int)
}

extension DetailDiaryService: BaseTargetType {
    var path: String {
        switch self {
        case .detailDiary(let diaryID):
            return URLConstant.diaryURL + "\(diaryID)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        switch self {
        case .detailDiary:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return NetworkConstant.tempTokenHeader
    }

}
