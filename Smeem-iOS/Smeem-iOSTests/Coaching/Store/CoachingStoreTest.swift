//
//  CoachingStore.swift
//  Smeem-iOSTests
//
//  Created by 황찬미 on 12/10/24.
//

import XCTest

@testable import Smeem_iOS

final class CoachingStoreTest: XCTestCase {
    
    var sut: CoachingStore!
    var service: CoachingServiceProtocol!

    override func setUpWithError() throws {
        service = CoachingService()
        sut = CoachingStore(service: service,
                           diaryResponse: PostDiaryResponse.empty)
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_첨삭데이터15개일때_10개로잘필터하는지() {
        // Given
        var filterResult = [CoachingResponse]()
        for _ in 1...15 {
            filterResult.append(CoachingResponse(originalSentence: "",
                                                   correctedSentence: "",
                                                   reason: "",
                                                   isCorrected: true))
        }
        
        var expectedResult = [CoachingResponse]()
        for _ in 1...10 {
            expectedResult.append(CoachingResponse(originalSentence: "",
                                                   correctedSentence: "",
                                                   reason: "",
                                                   isCorrected: true))
        }
        
        // When
        let outputResult = sut.filiterCorrection(filterResult)
        
        // Then
        XCTAssertEqual(outputResult, expectedResult)
    }
    
    func test_첨삭데이터0개일때_0개로잘필터하는지() {
        // Given
        var filterResult = [CoachingResponse]()
        for _ in 1...15 {
            filterResult.append(CoachingResponse(originalSentence: "",
                                                   correctedSentence: "",
                                                   reason: "",
                                                   isCorrected: false))
        }
        
        var expectedResult = [CoachingResponse]()
        
        // When
        let outputResult = sut.filiterCorrection(filterResult)
        
        // Then
        XCTAssertEqual(outputResult, expectedResult)
    }
}
