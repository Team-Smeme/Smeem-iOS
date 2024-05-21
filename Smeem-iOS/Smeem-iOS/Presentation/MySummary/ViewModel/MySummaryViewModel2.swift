
//
//  MySummaryViewModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 4/28/24.
//

import Foundation
import Combine

final class MySummaryViewMode2l: ViewModel {
    
    var provider: MySummaryServiceProtocol!
    
    private let mySmeemModel = ["방문일", "총 일기", "연속 일기", "배지"]
    
    struct Input {
        let mySummarySubject: PassthroughSubject<Void, Never>
        let myPlanSubject: PassthroughSubject<Void, Never>
        let myBadgeSubject: PassthroughSubject<Void, Never>
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
            .handleEvents(receiveSubscription: { _ in
                self.loadingViewSubject.send(true)
            })
            .flatMap { _ -> AnyPublisher<MySummaryResponse, Never> in
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
                .handleEvents(receiveCompletion: { _ in
                    self.loadingViewSubject.send(false)
                })
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let myPlanResult = input.myPlanSubject
            .handleEvents(receiveSubscription: { _ in
                self.loadingViewSubject.send(true)
            })
            .flatMap { _ -> AnyPublisher<MyPlanResponse, Never> in
                return Future<MyPlanResponse, Never> { promise in
                    self.provider.myPlanGetAPI { result in
                        switch result {
                        case .success(let response):
                            // 만약 데이터가 없다면
                            guard let data = response.data else {
//                                self.planSettingSubject.send(())
                                return
                            }
                        case .failure(let error):
                            self.errorSubject.send(error)
                        }
                    }
                }
                .handleEvents(receiveCompletion: { _ in
                    self.loadingViewSubject.send(false)
                })
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let myBadgeResult = input.myBadgeSubject
            .handleEvents(receiveSubscription: { _ in
                self.loadingViewSubject.send(true)
            })
            .flatMap { _ -> AnyPublisher<[MySummaryBadgeResponse], Never> in
                return Future<[MySummaryBadgeResponse], Never> { promise in
                    self.provider.myBadgeGetAPI { result in
                        switch result {
                        case .success(let response):
                            promise(.success(response))
                        case .failure(let error):
                            self.errorSubject.send(error)
                        }
                    }
                }
                .handleEvents(receiveCompletion: { _ in
                    self.loadingViewSubject.send(false)
                })
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let planSettingResult = planSettingSubject.eraseToAnyPublisher()

        let totalHasMyPlanResult = Publishers.CombineLatest3(mySummaryResult, myPlanResult, myBadgeResult)
            .map { result -> TotalMySummaryResponse in
                var clearCountArray: [Int] = []
                (1...result.1.clearCount).forEach { number in
                    clearCountArray.append(number)
                }
                return TotalMySummaryResponse(mySumamryText: self.mySmeemModel.map{$0},
                                              mySummaryNumber: [result.0.visitDays, result.0.diaryCount,
                                                                result.0.diaryComboCount, result.0.badgeCount],
                                              myPlan: MyPlanAppData(plan: result.1.plan,
                                                                    goal: result.1.goal,
                                                                    clearedCount: result.1.clearedCount,
                                                                    clearCount: clearCountArray),
                                              myBadge: result.2)
            }
            .eraseToAnyPublisher()
        
        let totalHasNotPlanResult = Publishers.CombineLatest3(mySummaryResult, planSettingResult, myBadgeResult)
            .map { result -> TotalMySummaryResponse in
                self.loadingViewSubject.send(false)
                return TotalMySummaryResponse(mySumamryText: self.mySmeemModel.map{$0},
                                              mySummaryNumber: [result.0.visitDays, result.0.diaryCount,
                                                                result.0.diaryComboCount, result.0.badgeCount],
                                              myPlan: nil,
                                              myBadge: result.2)
            }
            .eraseToAnyPublisher()
        
//        let totalHasNotPlanResult = Publishers.CombineLatest3(mySummaryResult, mySummaryResult, mySummaryResult)
//            .map { result -> TotalMySummaryResponse in
//                self.loadingViewSubject.send(false)
//                return TotalMySummaryResponse(mySumamryText: [""], mySummaryNumber: [123], myPlan: MyPlanAppData(plan: "",
//                                                                                                                 goal: "", clearedCount: 3, clearCount: [1]), myBadge: [MySummaryBadgeResponse(badgeId: 0, name: "", type: "", hasBadge: false, remainingNumber: 3, contentForNonBadgeOwner: "", contentForBadgeOwner: "", imageUrl: "", badgeAcquisitionRatio: 0.0)])
//            }
//            .eraseToAnyPublisher()
        
        let errorResult = errorSubject.eraseToAnyPublisher()
        let loadingViewResult = loadingViewSubject.eraseToAnyPublisher()
        
        
        return Output(totalHasMyPlanResult: totalHasMyPlanResult,
                      totalHasNotPlanResult: totalHasNotPlanResult,
                      errorResult: errorResult, loadingViewResult: loadingViewResult)
    }
    
}
