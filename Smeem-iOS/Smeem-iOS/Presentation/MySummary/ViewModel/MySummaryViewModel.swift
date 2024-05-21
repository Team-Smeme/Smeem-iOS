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
    var badgeData: [MySummaryBadgeResponse]!
    
    private let mySmeemModel = ["방문일", "총 일기", "연속 일기", "배지"]
    
    struct Input {
        let mySummarySubject: PassthroughSubject<Void, Never>
        let myPlanSubject: PassthroughSubject<Void, Never>
        let myBadgeSubject: PassthroughSubject<Void, Never>
        let badgeCellTapped: PassthroughSubject<Int, Never>
    }
    
    struct Output {
        let totalHasMyPlanResult: AnyPublisher<TotalMySummaryResponse, Never>
        let totalHasNotPlanResult: AnyPublisher<TotalMySummaryResponse, Never>
        let errorResult: AnyPublisher<SmeemError, Never>
        let loadingViewResult: AnyPublisher<Bool, Never>
        let badgeCellResult: AnyPublisher<MySummaryBadgeAppData, Never>
    }
    
    private var cancelBag = Set<AnyCancellable>()
    private let errorSubject = PassthroughSubject<SmeemError, Never>()
    private let nicknameDuplicateSubject = PassthroughSubject<Void, Never>()
    private let loadingViewSubject = PassthroughSubject<Bool, Never>()
    private let totalHasMyPlanSubject = PassthroughSubject<TotalMySummaryResponse, Never>()
    private let totalHasNotPlanSubject = PassthroughSubject<TotalMySummaryResponse, Never>()
    
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
            .flatMap { _ -> AnyPublisher<GeneralResponse<MyPlanResponse>, Never> in
                return Future<GeneralResponse<MyPlanResponse>, Never> { promise in
                    self.provider.myPlanGetAPI { result in
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
        
        let myBadgeResult = input.myBadgeSubject
            .handleEvents(receiveSubscription: { _ in
                self.loadingViewSubject.send(true)
            })
            .flatMap { _ -> AnyPublisher<[MySummaryBadgeResponse], Never> in
                return Future<[MySummaryBadgeResponse], Never> { promise in
                    self.provider.myBadgeGetAPI { result in
                        switch result {
                        case .success(let response):
                            self.badgeData = response
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

        Publishers.CombineLatest3(mySummaryResult, myPlanResult, myBadgeResult)
            .sink { result in
                if let _ = result.1.data {
                    var clearCountArray: [Int] = []
                    guard let planData = result.1.data else { return }
                    (1...planData.clearCount).forEach { number in
                        clearCountArray.append(number)
                    }
                    
                    let totalHasPlanResponse = TotalMySummaryResponse(mySumamryText: self.mySmeemModel.map{$0},
                                                                      mySummaryNumber: [result.0.visitDays, result.0.diaryCount,
                                                                                        result.0.diaryComboCount, result.0.badgeCount],
                                                                      myPlan: MyPlanAppData(plan: planData.plan,
                                                                                            goal: planData.goal,
                                                                                            clearedCount: planData.clearedCount,
                                                                                            clearCount: clearCountArray),
                                                                      myBadge: result.2)
                    self.totalHasMyPlanSubject.send(totalHasPlanResponse)
                } else {
                    let totalHasNotResponse = TotalMySummaryResponse(mySumamryText: self.mySmeemModel.map{$0},
                                                                     mySummaryNumber: [result.0.visitDays, result.0.diaryCount,
                                                                                       result.0.diaryComboCount, result.0.badgeCount],
                                                                     myPlan: nil,
                                                                     myBadge: result.2)
                    self.totalHasNotPlanSubject.send(totalHasNotResponse)
                }
                
            }
            .store(in: &cancelBag)
        
        let badgeCellResult = input.badgeCellTapped
            .map { indexPath -> MySummaryBadgeAppData in
                let badgeData = self.badgeData[indexPath]
                let ratioString = calculateBadgeRatio(ratio: badgeData.badgeAcquisitionRatio)
                return MySummaryBadgeAppData(badgeId: badgeData.badgeId,
                                             name: badgeData.name,
                                             type: badgeData.type,
                                             hasBadge: badgeData.hasBadge,
                                             remainingNumber: badgeData.remainingNumber,
                                             contentForNonBadgeOwner: badgeData.contentForNonBadgeOwner,
                                             contentForBadgeOwner: badgeData.contentForBadgeOwner,
                                             imageUrl: badgeData.imageUrl,
                                             badgeAcquisitionRatio: ratioString)
            }
            .eraseToAnyPublisher()
        
        func calculateBadgeRatio(ratio: Double) -> String {
            if String(ratio).count == 4 {
                return String(Int(ratio))
            } else {
                return String(ratio)
            }
        }
        
        let totalHasMyPlanResult = totalHasMyPlanSubject.eraseToAnyPublisher()
        let totalHasNotPlanResult = totalHasNotPlanSubject.eraseToAnyPublisher()
        let errorResult = errorSubject.eraseToAnyPublisher()
        let loadingViewResult = loadingViewSubject.eraseToAnyPublisher()
        
        
        return Output(totalHasMyPlanResult: totalHasMyPlanResult,
                      totalHasNotPlanResult: totalHasNotPlanResult,
                      errorResult: errorResult,
                      loadingViewResult: loadingViewResult,
                      badgeCellResult: badgeCellResult)
    }
    
}
