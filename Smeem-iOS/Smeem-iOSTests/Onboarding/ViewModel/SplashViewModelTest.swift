//
//  SplashViewModelTest.swift
//  Smeem-iOSTests
//
//  Created by 황찬미 on 3/20/24.
//

import XCTest
import Combine

@testable import Smeem_iOS

final class SplashViewModelTest: XCTestCase {
    
    private var viewModel: SplashViewModel!
    private var mockService: SplashServiceMock!
    private var appVersion: String!

    override func setUpWithError() throws {
        self.mockService = SplashServiceMock()
        self.viewModel = SplashViewModel(provider: mockService)
        self.appVersion = viewModel.appVersion
    }
    
    func test_강제업데이트안한유저_정확한데이터_return하는지() {
        // Given
        let result = self.viewModel.checkVersion(client: "2.0.3", force: "3.0.0")
        
        // When
        let expectedResult = true
        
        // Then
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_강제업데이트로하고온유저_정확한데이터_return하는지() {
        // Given
        let result = self.viewModel.checkVersion(client: self.appVersion, force: "3.0.0")
        
        // When
        let expectedResult = false
        
        // Then
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_이전업데이트로직유저_강제업데이트팝업잘뜨는지() {
        // Given
        let result = self.viewModel.checkVersion2(client: "2.0.3", now: "2.0.4", force: "3.0.0")
        
        // When
        let expectedResult = true
        
        // Then
        XCTAssertEqual(result, expectedResult)
    }

    override func tearDownWithError() throws {
        self.mockService = nil
        self.viewModel = nil
    }

}
