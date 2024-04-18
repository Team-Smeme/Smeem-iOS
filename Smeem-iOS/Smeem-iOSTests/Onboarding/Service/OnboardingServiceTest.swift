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
    
    var sut: OnboardingService!
    
    override func setUpWithError() throws {
        let mockProvider: MoyaProvider<OnboardingEndPoint> = makeProvider()
        sut = OnboardingService(provider: mockProvider)
    }
    
    func test_goalList_성공했을때() {
        let expectation = XCTestExpectation(description: "request")
        
        var outputResult: [Goal]!
        let expeactedResult = goalModel
        sut.trainingGoalGetAPI { result in
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
        sut.userPlanPathAPI(param: TrainingPlanRequest(target: "DEVELOP",
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
        sut.ninknameCheckAPI(userName: "짠미",
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
        sut.serviceAcceptedPatch(param: ServiceAcceptRequest(username: "짠미2",
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
    
    func test_서버에러일때() {
        var expeacted: SmeemError!
        do {
            try NetworkManager.statusCodeErrorHandling(statusCode: 500)
        } catch {
            guard let error = error as? SmeemError else { return }
            expeacted = error
        }
        XCTAssertEqual(expeacted, SmeemError.serverError)
    }
    
    func test_클라에러일때() {
        var expeacted: SmeemError!
        do {
            try NetworkManager.statusCodeErrorHandling(statusCode: 400)
        } catch {
            guard let error = error as? SmeemError else { return }
            expeacted = error
        }
        XCTAssertEqual(expeacted, SmeemError.clientError)
    }
    
    override func tearDownWithError() throws {
        sut = nil
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
                                   title: "DEVELOP",
                                   way: "주 5회 이상 smeem 랜덤 주제로 일기 작성하기",
                                   detail: "사전 없이 일기 완성\nsmeem 연속 일기 배지 획득")
    }
}
