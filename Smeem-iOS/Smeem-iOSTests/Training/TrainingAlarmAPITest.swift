//
//  TrainingAlarmAPITest.swift
//  Smeem-iOSTests
//
//  Created by 황찬미 on 2/19/24.
//

import XCTest
import Moya

@testable import Smeem_iOS

final class TrainingAlarmAPITest: XCTestCase, MockProviderProtocol {
    
    typealias targetEndPoint = OnboardingEndPoint
    var sut: OnboardingService!
    
    var viewModel: TrainingAlarmViewModel!

    override func setUpWithError() throws {
        var mockProvider: MoyaProvider<OnboardingEndPoint> = makeProvider()
        sut = OnboardingService(provider: mockProvider)
    }
    
    func test_goalList_성공했을때() {
        let expectation = XCTestExpectation(description: "request")
        
        var outputResult: [Goal]!
        sut.planList { result in
            switch result {
            case .success(let response):
                expectation.fulfill()
            case .failure(_):
                print("에러 없음")
            }
        }
        
        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(outputResult, goalModel)
    }

    override func tearDownWithError() throws {
        
    }
}

extension TrainingAlarmAPITest {
    var goalModel: [Goal] {
        return [Goal(goalType: "DEVELOP", name: "자기계발"),
                Goal(goalType: "HOBBY", name: "취미로 즐기기"),
                Goal(goalType: "APPLY", name: "현지 언어 체득"),
                Goal(goalType: "BUSINESS", name: "유창한 비즈니스 영어"),
                Goal(goalType: "EXAM", name: "어학 시험 고득점"),
                Goal(goalType: "NONE", name: "아직 모르겠어요")]
    }
}
