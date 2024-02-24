//
//  OnboardingServiceTest.swift
//  Smeem-iOSTests
//
//  Created by 황찬미 on 2/19/24.
//

import XCTest
import Moya

@testable import Smeem_iOS

final class OnboardingServiceTest: XCTestCase, MockProviderProtocol {
    
    typealias TargetEndPoint = OnboardingEndPoint
    
    var successSut: OnboardingService!
    var failure400Sut: OnboardingService!
    var failure500Sut: OnboardingService!
    
    override func setUpWithError() throws {
        let mockSuccessProvider: MoyaProvider<OnboardingEndPoint> = makeSuccessProvider()
        successSut = OnboardingService(provider: mockSuccessProvider)
        
        let mockFailure400Provider: MoyaProvider<OnboardingEndPoint> = makeFailure400Provider()
        failure400Sut = OnboardingService(provider: mockFailure400Provider)
        
        
        let mockFailure500Provider: MoyaProvider<OnboardingEndPoint> = makeFailure500Provider()
        failure500Sut = OnboardingService(provider: mockFailure500Provider)
    }
    
    func test_goalList_성공했을때() {
        let expectation = XCTestExpectation(description: "request")
        
        var outputResult: [Goal]!
        let expeactedResult = goalModel
        successSut.trainingGoalGetAPI { result in
            switch result {
            case .success(let response):
                outputResult = response
                expectation.fulfill()
            case .failure(let error):
                print(error)
            }
        }
        
        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(outputResult, expeactedResult)
    }
    
    func test_trainingUserPlanAPI_성공했을때() {
        let expectation = XCTestExpectation(description: "request")
        
        var outputResult: String!
        let expeactedResult = "회원 학습 계획 업데이트 성공"
        successSut.userPlanPathAPI(param: TrainingPlanRequest(target: "DEVELOP",
                                                              trainingTime: TrainingTime(day: "AM",
                                                                                         hour: 22,
                                                                                         minute: 0),
                                                              hasAlarm: true),
                                   accessToken: "access Token") { result in
            switch result {
            case .success(let response):
                outputResult = response.message
                expectation.fulfill()
            case .failure(let error):
                print(error)
            }
        }
        
        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(outputResult, expeactedResult)
    }
    
    func test_checkNicknameAPI_성공했을때() {
        let expectation = XCTestExpectation(description: "request")
        
        var outputResult: Bool!
        let expeactedResult = false
        successSut.ninknameCheckAPI(userName: "짠미",
                                    accessToken: "access Token") { result in
            switch result {
            case .success(let response):
                outputResult = response.isExist
                expectation.fulfill()
            case .failure(let error):
                print(error)
            }
        }
        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(outputResult, expeactedResult)
    }
    
    func test_serviceAcceptedAPI_성공했을때() {
        let expectation = XCTestExpectation(description: "request")
        
        var outputResult: String!
        let expeactedResult = "웰컴 배지"
        successSut.serviceAcceptedPatch(param: ServiceAcceptRequest(username: "짠미2",
                                                                    termAccepted: true),
                                        accessToken: "access token") { result in
            switch result {
            case .success(let response):
                outputResult = response.badges[0].name
                expectation.fulfill()
            case .failure(let error):
                print(error)
            }
        }
        
        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(outputResult, expeactedResult)
    }
    
    func test_goalListAPI_400에러일때() {
        let expectation = XCTestExpectation()
        
        var outputResult: SmeemError!
        let expeactedResult = SmeemError.clientError
        failure400Sut.trainingGoalGetAPI { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                outputResult = error
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(outputResult, expeactedResult)
    }
    
    func test_trainingUserPlanAPI_500에러일때() {
        let expectation = XCTestExpectation()
        
        var outputResult: SmeemError!
        let expeactedResult = SmeemError.serverError
        failure500Sut.userPlanPathAPI(param: TrainingPlanRequest(target: "DEVELOP",
                                                                 trainingTime: TrainingTime(day: "AM",
                                                                                         hour: 22,
                                                                                         minute: 0),
                                                                 hasAlarm: true),
                                      accessToken: "access Token") { result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                outputResult = error
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(outputResult, expeactedResult)
    }
    
    override func tearDownWithError() throws {
        successSut = nil
        failure400Sut = nil
        failure500Sut = nil
    }
}

extension OnboardingServiceTest {
    var goalModel: [Goal] {
        return [Goal(goalType: "DEVELOP", name: "자기계발"),
                Goal(goalType: "HOBBY", name: "취미로 즐기기"),
                Goal(goalType: "APPLY", name: "현지 언어 체득"),
                Goal(goalType: "BUSINESS", name: "유창한 비즈니스 영어"),
                Goal(goalType: "EXAM", name: "어학 시험 고득점"),
                Goal(goalType: "NONE", name: "아직 모르겠어요")]
    }
    
    var goalDetailModel: TrainingWayResponse {
        return TrainingWayResponse(name: "자기계발",
                                   way: "주 5회 이상 smeem 랜덤 주제로 일기 작성하기",
                                   detail: "사전 없이 일기 완성\nsmeem 연속 일기 배지 획득")
    }
}
