//
//  TrainingAlarmTest.swift
//  Smeem-iOSTests
//
//  Created by 황찬미 on 2/18/24.
//

import XCTest
import Combine

@testable import Smeem_iOS

final class TrainingAlarmViewModelTest: XCTestCase {
    
    var provider: OnboardingServiceMock!
    var viewModel: TrainingAlarmViewModel!
    var input: TrainingAlarmViewModel.Input!
    var output: TrainingAlarmViewModel.Output!
    var cancelBag: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        self.provider = OnboardingServiceMock()
        self.viewModel = TrainingAlarmViewModel(provider: provider)
        self.cancelBag = Set<AnyCancellable>()
        
        self.input = TrainingAlarmViewModel.Input(viewWillAppearSubject: PassthroughSubject<Void, Never>(),
                                                  alarmTimeSubject: PassthroughSubject<AlarmTimeAppData, Never>(),
                                                  alarmDaySubject: PassthroughSubject<Set<String>, Never>(),
                                                  alarmButtonTapped: PassthroughSubject<AlarmType, Never>(),
                                                  nextFlowSubject: PassthroughSubject<Void, Never>(),
                                                  amplitudeSubject: PassthroughSubject<Void, Never>())
        self.output = viewModel.transform(input: input)
    }
    
    func test_요일데이터가들어왔을때_버튼활성화되는지() {
        // Given
        let expectation = XCTestExpectation(description: "button type expectedResult received")
        let value: Set<String> = ["MON", "TUE", "WED", "THU", "FRI"]
        
        // When
        var outputResult: SmeemButtonType!
        let expectedResult: SmeemButtonType = .enabled
        
        output.buttonTypeResult
            .sink { type in
                outputResult = type
                expectation.fulfill()
            }
            .store(in: &cancelBag)
        
        input.alarmDaySubject.send(value)
        
        // Then
        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(outputResult, expectedResult)
    }
    
    func test_비어있는요일데이터일때_버튼비활성화되는지() {
        // Given
        let expectation = XCTestExpectation(description: "button type expectedResult received")
        let value: Set<String> = []
        
        // When
        var outputResult: SmeemButtonType!
        let expectedResult: SmeemButtonType = .notEnabled
        
        output.buttonTypeResult
            .sink { type in
                outputResult = type
                expectation.fulfill()
            }
            .store(in: &cancelBag)
        
        input.alarmDaySubject.send(value)
        
        // Then
        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(outputResult, expectedResult)
    }
    
    func test_PM_12_00_시간데이터_계산잘되는지() {
        // Given
        let value = AlarmTimeAppData(hour: "12", minute: "00", dayAndNight: "PM")
        
        // When
        input.alarmTimeSubject.send(value)
        
        let outputHourResult = viewModel.trainingPlanRequest.trainingTime.hour
        let outputMinuteResult = viewModel.trainingPlanRequest.trainingTime.minute
        
        let expectedHourResult = 12
        let expectedMinuteResult = 0
        
        // Then
        XCTAssertEqual(outputHourResult, expectedHourResult)
        XCTAssertEqual(outputMinuteResult, expectedMinuteResult)
    }
    
    func test_AM_12_00_시간데이터_계산잘되는지() {
        // Given
        let value = AlarmTimeAppData(hour: "12", minute: "00", dayAndNight: "AM")
        
        // When
        input.alarmTimeSubject.send(value)
        
        let outputHourResult = viewModel.trainingPlanRequest.trainingTime.hour
        let outputMinuteResult = viewModel.trainingPlanRequest.trainingTime.minute
        
        let expectedHourResult = 24
        let expectedMinuteResult = 0
        
        // Then
        XCTAssertEqual(outputHourResult, expectedHourResult)
        XCTAssertEqual(outputMinuteResult, expectedMinuteResult)
    }
    
    func test_AM_3_30_시간데이터_계산잘되는지() {
        // Given
        let value = AlarmTimeAppData(hour: "3", minute: "30", dayAndNight: "AM")
        
        // When
        input.alarmTimeSubject.send(value)
        
        let outputHourResult = viewModel.trainingPlanRequest.trainingTime.hour
        let outputMinuteResult = viewModel.trainingPlanRequest.trainingTime.minute
        
        let expectedHourResult = 3
        let expectedMinuteResult = 30
        
        // Then
        XCTAssertEqual(outputHourResult, expectedHourResult)
        XCTAssertEqual(outputMinuteResult, expectedMinuteResult)
    }
    
    func test_PM_11_30_시간데이터_계산잘되는지() {
        // Given
        let value = AlarmTimeAppData(hour: "11", minute: "30", dayAndNight: "PM")
        
        // When
        input.alarmTimeSubject.send(value)
        
        let outputHourResult = viewModel.trainingPlanRequest.trainingTime.hour
        let outputMinuteResult = viewModel.trainingPlanRequest.trainingTime.minute
        
        let expectedHourResult = 23
        let expectedMinuteResult = 30
        
        // Then
        XCTAssertEqual(outputHourResult, expectedHourResult)
        XCTAssertEqual(outputMinuteResult, expectedMinuteResult)
    }
    
    func test_alarmAPI_잘호출되는지() {
        // Given
        let expectation = XCTestExpectation(description: "button type expectedResult received")
        
        // When
        
        output.nicknameResult
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancelBag)
        
        input.nextFlowSubject.send(())
        
        // Then
        wait(for: [expectation], timeout: 0.5)
    }
    
    override func tearDownWithError() throws {
        self.viewModel = nil
        self.cancelBag = nil
        
        self.input = nil
        self.output = nil
    }
}
