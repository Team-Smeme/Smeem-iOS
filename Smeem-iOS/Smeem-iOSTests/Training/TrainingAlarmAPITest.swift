//
//  TrainingAlarmAPITest.swift
//  Smeem-iOSTests
//
//  Created by 황찬미 on 2/19/24.
//

import XCTest
import Moya

@testable import Smeem_iOS

final class TrainingAlarmAPITest: XCTestCase {
    
    private var sut: OnboardingService!
    private var mockProvider: MoyaProvider<OnboardingEndPoint>!
    
    var viewModel: TrainingAlarmViewModel!

    override func setUpWithError() throws {
        
        let endpointClosure = { (target: OnboardingEndPoint) -> Endpoint in
            return Endpoint(url: target.path,
                            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
        }
        mockProvider = MoyaProvider<OnboardingEndPoint>(endpointClosure: endpointClosure,
                                                        stubClosure: MoyaProvider.immediatelyStub)
        sut = OnboardingService(provider: mockProvider)
    }
    
//    func test_alarmAPI_잘호출되는지() {
//        let expectation = XCTestExpectation(description: "request")
//        
//        var outputResult: [Goal]!
//        sut.planList { result in
//            print("이게 뭔데", result)
//            switch result {
//            case .success(let response):
//                print("네트워크 성공")
//                outputResult = response
//                expectation.fulfill()
//            case .failure(let error):
//                print("일단 이렇게")
//            }
//        }
//        
//        wait(for: [expectation], timeout: 2.0)
//        XCTAssertEqual(outputResult, goalModel)
//    }

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
