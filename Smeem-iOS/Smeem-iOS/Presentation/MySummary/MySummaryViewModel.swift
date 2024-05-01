//
//  MySummaryViewModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 4/28/24.
//

import Foundation
import Combine

final class MySummaryViewModel: ViewModel {
    
    var provider: MySummaryServiceProtocol!
    
    private let mySmeemModel = ["방문일", "총 일기", "연속 일기", "배지"]
    
    struct Input {
        let mySummarySubject: PassthroughSubject<Void, Never>
        let myPlanSubject: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let totalHasMyPlanResult: AnyPublisher<TotalMySummaryResponse, Never>
        let totalHasNotPlanResult: AnyPublisher<TotalMySummaryResponse, Never>
        let errorResult: AnyPublisher<SmeemError, Never>
        let loadingViewResult: AnyPublisher<Bool, Never>
    }
    
    private var cancelBag = Set<AnyCancellable>()
    private let errorSubject = PassthroughSubject<SmeemError, Never>()
    private let nicknameDuplicateSubject = PassthroughSubject<Void, Never>()
    private let loadingViewSubject = PassthroughSubject<Bool, Never>()
    private let planSettingSubject = PassthroughSubject<Void, Never>()
    
    init(provider: MySummaryServiceProtocol) {
        self.provider = provider
    }
    
    func transform(input: Input) -> Output {
        let mySummaryResult = input.mySummarySubject
            .flatMap { _ -> AnyPublisher<MySummaryResponse, Never> in
                self.loadingViewSubject.send(true)
                return Future<MySummaryResponse, Never> { promise in
                    self.provider.mySummaryGetAPI { result in
                        switch result {
                        case .success(let response):
                            promise(.success(response))
                        case .failure(let error):
                            self.errorSubject.send(error)
                        }
                    }
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let myPlanResult = input.myPlanSubject
            .flatMap { _ -> AnyPublisher<MyPlanResponse, Never> in
                self.loadingViewSubject.send(true)
                return Future<MyPlanResponse, Never> { promise in
                    self.provider.myPlanGetAPI { result in
                        switch result {
                        case .success(let response):
                            // 만약 데이터가 없다면
                            guard let data = response.data else {
                                self.planSettingSubject.send(())
                                return
                            }
                            
                            promise(.success(data))
                        case .failure(let error):
                            self.errorSubject.send(error)
                        }
                    }
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let planSettingResult = planSettingSubject.eraseToAnyPublisher()
        let loadingViewResult = loadingViewSubject.eraseToAnyPublisher()
        
        let totalHasMyPlanResult = Publishers.Zip(mySummaryResult, myPlanResult)
            .map { result -> TotalMySummaryResponse in
                self.loadingViewSubject.send(false)
                return TotalMySummaryResponse(mySumamryText: self.mySmeemModel.map{$0},
                                              mySummaryNumber: [result.0.visitDays, result.0.diaryCount,
                                                                result.0.diaryComboCount, result.0.badgeCount],
                                              myPlan: result.1)
            }
            .eraseToAnyPublisher()
        
        let totalHasNotPlanResult = Publishers.Zip(mySummaryResult, planSettingResult)
            .map { result -> TotalMySummaryResponse in
                self.loadingViewSubject.send(false)
                return TotalMySummaryResponse(mySumamryText: self.mySmeemModel.map{$0},
                                              mySummaryNumber: [result.0.visitDays, result.0.diaryCount,
                                                                result.0.diaryComboCount, result.0.badgeCount],
                                              myPlan: nil)
            }
            .eraseToAnyPublisher()
        
        let errorResult = errorSubject
            .map { smeemError in
                self.loadingViewSubject.send(false)
                return smeemError
            }
            .eraseToAnyPublisher()
        
        
        return Output(totalHasMyPlanResult: totalHasMyPlanResult, totalHasNotPlanResult: totalHasNotPlanResult,
                      errorResult: errorResult, loadingViewResult: loadingViewResult)
    }
    
}
