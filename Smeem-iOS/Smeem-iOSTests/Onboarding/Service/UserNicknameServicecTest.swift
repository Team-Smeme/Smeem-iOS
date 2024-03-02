//
//  UserNicknameServicecTest.swift
//  Smeem-iOSTests
//
//  Created by 황찬미 on 2/24/24.
//

import XCTest
import Moya

@testable import Smeem_iOS

final class UserNicknameServicecTest: XCTestCase, MockProviderProtocol {
    
    typealias TargetEndPoint = OnboardingEndPoint
    
    var sut: OnboardingService!
    
    override func setUpWithError() throws {
        let mockSuccessProvider: MoyaProvider<OnboardingEndPoint> = makeSuccessProvider()
        sut = OnboardingService(provider: mockSuccessProvider)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}
