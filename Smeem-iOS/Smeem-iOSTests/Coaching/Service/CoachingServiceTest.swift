//
//  CoachingServiceTest.swift
//  Smeem-iOSTests
//
//  Created by 황찬미 on 11/24/24.
//

import XCTest
import Moya

@testable import Smeem_iOS

final class CoachingServiceTest: XCTestCase {
    
    var sut: CoachingService!
    
    override func setUpWithError() throws {
        sut = CoachingService(coachingProvider: makeCoachingProvider(), detailDiaryProvider: makeDetailDiaryProvider())
    }
    
    func test_coaching_성공했을때() async throws {
        let expectation = XCTestExpectation(description: "request")

        let expeactedResult = coachingModel
        let outputResult: CoachingsResponse = try await sut.coachingPostAPI(diaryID: 0)
        
        XCTAssertEqual(outputResult, expeactedResult)
    }
    
    func test_detailDiary_성공했을때() async throws {
        let expectation = XCTestExpectation(description: "request")

        let expeactedResult = detailDiaryResponse
        let outputResult: DetailDiaryResponse = try await sut.detailDiaryAPI(diaryID: 0)
        
        XCTAssertEqual(outputResult, expeactedResult)
    }
}

extension CoachingServiceTest {
    var coachingModel: CoachingsResponse {
        return CoachingsResponse(corrections: [CoachingResponse(original_sentence: "original text",
                                                                corrected_sentence: "corrected text",
                                                                reason: "수정된 문구입니다.",
                                                                is_corrected: true)])
    }
    
    var detailDiaryResponse: DetailDiaryResponse {
        return DetailDiaryResponse(diaryId: 0,
                                   topic: "주제",
                                   content: "일기 내용입니다",
                                   createdAt: "2024년 5월 18일",
                                   username: "찬미")
    }
}

extension CoachingServiceTest {
    func makeCoachingProvider() -> MoyaProvider<CoachingEndPoint> {
        let endpointClosure = { (target: CoachingEndPoint) -> Endpoint in
            return Endpoint(url: target.path,
                            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
        }
        return MoyaProvider<CoachingEndPoint>(endpointClosure: endpointClosure,
                                              stubClosure: MoyaProvider.immediatelyStub)
    }
    
    func makeDetailDiaryProvider() -> MoyaProvider<DetailDiaryEndPoint> {
        let endpointClosure = { (target: DetailDiaryEndPoint) -> Endpoint in
            return Endpoint(url: target.path,
                            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
        }
        return MoyaProvider<DetailDiaryEndPoint>(endpointClosure: endpointClosure,
                                                 stubClosure: MoyaProvider.immediatelyStub)
    }
}
