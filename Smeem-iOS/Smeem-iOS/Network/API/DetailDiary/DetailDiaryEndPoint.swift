//
//  DetailDiaryService.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/25.
//

import Moya
import Foundation

enum DetailDiaryEndPoint {
    case detailDiary(diaryID: Int)
    case deleteDiary(diaryID: Int)
}

extension DetailDiaryEndPoint: BaseTargetType {
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
        return ["Content-Type": "application/json",
                "Authorization": "Bearer " + UserDefaultsManager.accessToken]
    }
}

extension DetailDiaryEndPoint {
    var sampleData: Data {
        switch self {
        case .detailDiary:
            return Data(
                """
                {
                    "success": true,
                    "message": "학습 상세 조회",
                    "data": {
                            "diaryId": 0,
                            "topic": "주제",
                            "content": "일기 내용입니다",
                            "createdAt": "2024년 5월 18일",
                            "username": "찬미",
                            "isUpdated": true,
                            "corrections": [
                                        {
                                            "originalSentence": "original text",
                                            "correctedSentence": "corrected text",
                                            "reason": "수정된 문구입니다.",
                                            "isCorrected": true
                                        }
                                   ],
                            "correctionCount": 0,
                            "correctionMaxCount": 1
                    }
                }
                """.utf8)
        case .deleteDiary:
            return Data()
        }
    }
}
