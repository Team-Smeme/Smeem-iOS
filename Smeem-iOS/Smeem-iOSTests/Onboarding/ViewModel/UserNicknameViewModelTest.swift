//
//  UserNicknameViewModelTest.swift
//  Smeem-iOSTests
//
//  Created by 황찬미 on 2/24/24.
//

import XCTest
import Combine

@testable import Smeem_iOS

final class UserNicknameViewModelTest: XCTestCase, MockProviderProtocol {
    
    typealias TargetEndPoint = OnboardingEndPoint
    
    private var provider: OnboardingServiceMock!
    private var viewModel: UserNicknameViewModel!
    private var input: UserNicknameViewModel.Input!
    private var output: UserNicknameViewModel.Output!
    private var cancelBag: Set<AnyCancellable>!

    override func setUpWithError() throws {
        self.provider = OnboardingServiceMock()
        self.viewModel = UserNicknameViewModel(provider: provider)
        self.viewModel.provider = OnboardingService(provider: makeSuccessProvider())
        self.input = UserNicknameViewModel.Input(textFieldSubject: PassthroughSubject<String, Never>(),
                                                 nextButtonTapped: PassthroughSubject<String, Never>())
        self.output = viewModel.transform(input: input)
        self.cancelBag = Set<AnyCancellable>()
    }
    
    func test_첫번째공백포함닉네임_잘처리하는지() {
        // Given
        let value = " 짠미"
        
        // When
        var outputResult: SmeemButtonType!
        let expectedResult = SmeemButtonType.notEnabled
        
        output.textFieldResult
            .sink { type in
                outputResult = type
            }
            .store(in: &cancelBag)
        
        input.textFieldSubject.send(value)
        
        // Then
        XCTAssertEqual(outputResult, expectedResult)
    }
    
    func test_공백포함열글자_잘처리하는지() {
        // Given
        let value = " 공백포함   10글자넘었을때   "
        
        // When
        var outputResult: SmeemButtonType!
        let expectedResult = SmeemButtonType.notEnabled
        
        output.textFieldResult
            .sink { type in
                outputResult = type
            }
            .store(in: &cancelBag)
        
        input.textFieldSubject.send(value)
        
        // Then
        XCTAssertEqual(outputResult, expectedResult)
    }
    
    func test_열글자안넘은닉네임_잘처리하는지() {
        // Given
        let value = "짠미"
        
        // When
        var outputResult: SmeemButtonType!
        let expectedResult = SmeemButtonType.enabled
        
        output.textFieldResult
            .sink { type in
                outputResult = type
            }
            .store(in: &cancelBag)
        
        input.textFieldSubject.send(value)
        
        // Then
        XCTAssertEqual(outputResult, expectedResult)
    }
    
    func test_닉네임중복검사API_성공했을때() {
        // Given
        let expectation = XCTestExpectation()
        let value = "예시 닉네임"
        
        // When
        output.nextButtonResult
            .sink { response in
                expectation.fulfill()
            }
            .store(in: &cancelBag)
        
        input.nextButtonTapped.send(value)
        
        // Then
        wait(for: [expectation], timeout: 0.5)
    }

    override func tearDownWithError() throws {
        self.viewModel = nil
        self.input = nil
        self.output = nil
        self.cancelBag = nil
    }
}
