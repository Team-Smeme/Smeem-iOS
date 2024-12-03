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
    static let empty = CoachingsResponse(corrections: [CoachingResponse(originalSentence: "I have went to the park yesterdayI have went to the park yesterdayI have went to the park yesterdayI have went to the park yesterday",
                                                                        correctedSentence: "I went to the park yesterdayI went to the park yesterdayI went to the park yesterdayI went to the park yesterdayI went to the park yesterday",
                                                                        reason: "현재완료 시제인 have went는 과거 시제인 went로 바꾸는 것이 맞습니다. yesterday와 함께 사용할 때는 단순 과거 시제를 사용해야 합니다.",
                                                                        isCorrected: true),
                                                       CoachingResponse(originalSentence: "I have went to the park yesterdayI have went to the park yesterdayI have went럼뉴름ㄴ람ㄴㄹ 마넝롬나ㅣㅓㅇㄹ ㅗㅁ나ㅓㅇ롬나어롬나어롬나러ㅗㅁ나러 ㅗㄴ마러ㅗㅁ너ㅏ롬 ㄴ라ㅓ ㅗㄴㅁ라 왜 갑자 I have went to the park yesterdayI have went to the park yesterdayI have went to the park yesterdayI have went to the park yesterdayI have went to the park yesterday",
                                                                        correctedSentence: "I went to the park yesterdayI went to the park yesterdayI went to the park yesterday",
                                                                        reason: "이러 이러한 이유로 이건 맞습니다",
                                                                        isCorrected: true)])
    static let sample = CoachingsResponse(
        corrections: [
            CoachingResponse(
                originalSentence: "I should have skimmed the previous season - Avatar1..",
                correctedSentence: "I should have skimmed the previous season - Avatar 1.",
                reason: "Avatar1은 'Avatar 1'으로 띄어쓰기해야 하며, 중복된 마침표 하나를 제거해야 합니다.",
                isCorrected: true
            ),
            CoachingResponse(
                originalSentence: "I think 두팔 who is my boyfriend should study before wathcing….",
                correctedSentence: "I think 두팔, who is my boyfriend, should study before watching.",
                reason: "'wathcing'을 'watching'으로 수정하고, 불필요한 점을 제거했습니다. 또한 쉼표를 추가하여 문장을 읽기 쉽게 만들었습니다.",
                isCorrected: true
            ),
            CoachingResponse(
                originalSentence: "In my personal opinion, the jjin main character of Avatar2 is not Sully, but his son.",
                correctedSentence: "In my personal opinion, the real main character of Avatar 2 is not Sully, but his son.",
                reason: "'jjin'은 'real'로 대체하였고, 'Avatar2'를 'Avatar 2'로 띄어쓰기 처리하였습니다.",
                isCorrected: true
            )
        ]
    )
}

struct CoachingResponse: Codable {
    let originalSentence: String
    let correctedSentence: String
    let reason: String
    let isCorrected: Bool
}
