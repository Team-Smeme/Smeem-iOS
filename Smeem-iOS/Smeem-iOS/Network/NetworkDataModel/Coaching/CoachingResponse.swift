//
//  CoachingResponse.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 11/17/24.
//

import Foundation

struct CoachingsResponse: Codable {
    var corrections: [CoachingResponse]
}

extension CoachingsResponse {
    static let empty = CoachingsResponse(corrections: [CoachingResponse(original_sentence: "I have went to the park yesterdayI have went to the park yesterdayI have went to the park yesterdayI have went to the park yesterday",
                                                                        corrected_sentence: "I went to the park yesterdayI went to the park yesterdayI went to the park yesterdayI went to the park yesterdayI went to the park yesterday",
                                                                        reason: "현재완료 시제인 have went는 과거 시제인 went로 바꾸는 것이 맞습니다. yesterday와 함께 사용할 때는 단순 과거 시제를 사용해야 합니다.",
                                                                        is_corrected: true),
                                                       CoachingResponse(original_sentence: "I have went to the park yesterdayI have went to the park yesterdayI have went럼뉴름ㄴ람ㄴㄹ 마넝롬나ㅣㅓㅇㄹ ㅗㅁ나ㅓㅇ롬나어롬나어롬나러ㅗㅁ나러 ㅗㄴ마러ㅁ너ㅏ롬 ㄴ라ㅓ ㅗㄴㅁ라 왜 갑자 I have went to the park yesterdayI have went to the park yesterdayI have went to the park yesterdayI have went to the park yesterdayI have went to the park yesterday",
                                                                                                                           corrected_sentence: "I went to the park yesterdayI went to the park yesterdayI went to the park yesterday",
                                                                                                                           reason: "이러 이러한 이유로 이건 맞습니다",
                                                                                                                           is_corrected: true)])
}

struct CoachingResponse: Codable {
    let original_sentence: String
    let corrected_sentence: String
    let reason: String
    let is_corrected: Bool
}
