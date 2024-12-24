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
    private var beforeAppVersion: String!
    private var afterAppVersion: String!
    private var forceVersion: String!

    override func setUpWithError() throws {
        self.mockService = SplashServiceMock()
        self.viewModel = SplashViewModel(provider: mockService)
        self.beforeAppVersion = "3.0.1"
        self.afterAppVersion = "3.1.0"
        self.forceVersion = "3.1.0"
    }
    
    func test_강제업데이트안한유저_정확한데이터_return하는지() {
        // Given
        let result = self.viewModel.checkVersion(client: self.beforeAppVersion, force: self.forceVersion)
        
        // When
        let expectedResult = true
        
        // Then
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_강제업데이트로하고온유저_정확한데이터_return하는지() {
        // Given
        let result = self.viewModel.checkVersion(client: self.afterAppVersion, force: self.forceVersion)
        
        // When
        let expectedResult = false
        
        // Then
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_첫업데이트로직유저_강제업데이트팝업잘뜨는지() {
        // Given
        let result = self.viewModel.checkVersion2(client: "2.0.3", now: "2.0.4", force: self.forceVersion)
        
        // When
        let expectedResult = true
        
        // Then
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_두번째업데이트로직유저_강제업데이트팝업잘뜨는지() {
        // Given
        let result = self.viewModel.checkVersion3(client: self.beforeAppVersion, force: self.forceVersion)
        
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
