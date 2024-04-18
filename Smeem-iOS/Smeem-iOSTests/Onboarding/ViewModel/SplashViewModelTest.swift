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

    override func setUpWithError() throws {
        self.mockService = SplashServiceMock()
        self.viewModel = SplashViewModel(provider: mockService)
    }
    
    func test_강제업데이트안한유저_정확한데이터_return하는지() {
        // Given
        let result = self.viewModel.checkVersion(client: "2.0.0", now: "2.0.1", force: "3.0.0")
        
        // When
        let expectedResult = true
        
        // Then
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_강제업데이트로하고온유저_정확한데이터_return하는지() {
        // Given
        let result = self.viewModel.checkVersion(client: "2.0.1", now: "2.0.1", force: "3.0.0")
        
        // When
        let expectedResult = false
        
        // Then
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_강제업데이트하지않아도되는유저_정확한데이터_return하는지() {
        // Given
        let result = self.viewModel.checkVersion(client: "2.0.1", now: "2.0.1", force: "2.0.0")
        
        // When
        let expectedResult = false
        
        // Then
        XCTAssertEqual(result, expectedResult)
    }

    override func tearDownWithError() throws {
        self.mockService = nil
        self.viewModel = nil
    }

}
