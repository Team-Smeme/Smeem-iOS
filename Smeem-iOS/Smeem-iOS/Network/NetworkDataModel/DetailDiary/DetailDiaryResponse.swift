//
//  DetailDiaryResponse.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/25.
//

struct DetailDiaryResponse: Codable, Equatable {
    let diaryId: Int
    let topic: String
    var content: String
    let createdAt: String
    let username: String
    let isUpdated: Bool // JSON 키에 맞게 수정
    var corrections: [CoachingResponse] // JSON 구조에 맞게 수정
    let correctionCount: Int
    let correctionMaxCount: Int

    static func == (lhs: DetailDiaryResponse, rhs: DetailDiaryResponse) -> Bool {
        return lhs.diaryId == rhs.diaryId
    }
}

//struct CorrentionsData: Codable {
//    let correntionId: Int
//    let before: String
//    let after: String
//}

extension DetailDiaryResponse {
    static let empty = DetailDiaryResponse(diaryId: 0, topic: "", content: "테스트임?", createdAt: "그래", username: "그래", isUpdated: true, corrections: [CoachingResponse(originalSentence: "I have went to the park yesterdayI have went to the park yesterdayI have went to the park yesterdayI have went to the park yesterday",
                                                                                                                                                                     correctedSentence: "I went to the park yesterdayI went to the park yesterdayI went to the park yesterdayI went to the park yesterdayI went to the park yesterday",
                                                                                                                                                                     reason: "현재완료 시제인 have went는 과거 시제인 went로 바꾸는 것이 맞습니다. yesterday와 함께 사용할 때는 단순 과거 시제를 사용해야 합니다.",
                                                                                                                                                                     isCorrected: true),
                                                                                                                                                    CoachingResponse(originalSentence: "I have went to the park yesterdayI have went to the park yesterdayI have went럼뉴름ㄴ람ㄴㄹ 마넝롬나ㅣㅓㅇㄹ ㅗㅁ나ㅓㅇ롬나어롬나어롬나러ㅗㅁ나러 ㅗㄴ마러ㅗㅁ너ㅏ롬 ㄴ라ㅓ ㅗㄴㅁ라 왜 갑자 I have went to the park yesterdayI have went to the park yesterdayI have went to the park yesterdayI have went to the park yesterdayI have went to the park yesterday",
                                                                                                                                                                     correctedSentence: "I went to the park yesterdayI went to the park yesterdayI went to the park yesterday",
                                                                                                                                                                     reason: "이러 이러한 이유로 이건 맞습니다",
                                                                                                                                                                     isCorrected: true)], correctionCount: 0, correctionMaxCount: 0)
}

//struct CoachingResponse: Codable, Equatable {
//    let originalSentence: String
//    let correctedSentence: String
//    let reason: String
//    let isCorrected: Bool
//
//    enum CodingKeys: String, CodingKey {
//        case originalSentence = "originalSentence"
//        case correctedSentence = "correctedSentence"
//        case reason
//        case isCorrected = "isCorrected"
//    }
//}
