//
//  ServiceAcceptViewModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2024/02/08.
//

import Foundation
import Combine

struct totalViewStateModel {
    let totalViewState: Bool
    let indexPathArray: Set<Int>
}

struct cellStateModel {
    let cellState: Bool
    let indexPath: Int
    let buttonType: SmeemButtonType
}

final class ServiceAcceptViewModel: ViewModel {
    
    struct Input {
        let totalViewTapped: PassthroughSubject<Void, Never>
        let cellSelected: PassthroughSubject<Int, Never>
        let cellDeselected: PassthroughSubject<Int, Never>
        let cellIndexSubject: PassthroughSubject<Int, Never>
        let completeButtonTapped: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let totalViewResult: AnyPublisher<totalViewStateModel, Never>
        let cellResult: AnyPublisher<cellStateModel, Never>
        let cellIndexResult: AnyPublisher<URL, Never>
        let totalViewStateResult: AnyPublisher<Bool, Never>
        let completeButtonResult: AnyPublisher<[PopupBadge], Never>
        let errorSubject: AnyPublisher<SmeemError, Never>
        let loadingViewSubject: AnyPublisher<Bool, Never>
    }
    
    private let totalViewSubject = PassthroughSubject<(Bool, Int), Never>()
    private let errorSubject = PassthroughSubject<SmeemError, Never>()
    private let loadingViewSubject = PassthroughSubject<Bool, Never>()
    private var totalViewState = false
    private var indexPathArray: Set<Int> = []
    
    var nickname = ""
    
    func transform(input: Input) -> Output {
        let totalViewResult = input.totalViewTapped
            .map { _ in
                self.totalViewState = !self.totalViewState
                self.indexPathArray = self.totalViewState ? [0, 1, 2] : []
                return totalViewStateModel(totalViewState: self.totalViewState,
                                           indexPathArray: self.indexPathArray)
            }
            .eraseToAnyPublisher()
        
        let cellSelectedResult = input.cellSelected
            .map { indexPath in
                self.indexPathArray.insert(indexPath)
                self.totalViewSubject.send((true, self.indexPathArray.count))
                return cellStateModel(cellState: true,
                                      indexPath: indexPath,
                                      buttonType: self.validateServiceAccept())
            }
            .eraseToAnyPublisher()
        
        let cellDeselectedResult = input.cellDeselected
            .map { indexPath in
                self.indexPathArray.remove(indexPath)
                self.totalViewSubject.send((false, self.indexPathArray.count))
                return cellStateModel(cellState: false,
                                      indexPath: indexPath,
                                      buttonType: self.validateServiceAccept())
            }
            .eraseToAnyPublisher()
        
        let cellIndexResult = input.cellIndexSubject
            .map { indexPath in
                return self.setNotionUrl(indexPath: indexPath)
            }
            .eraseToAnyPublisher()
        
        let cellResult = Publishers.Merge(cellSelectedResult, cellDeselectedResult).eraseToAnyPublisher()
        
        /// cell이 모두 클릭되었거나, 하나라도 해제가 되었을 때 totalView 활성화
        let totalViewStateSubject = totalViewSubject
            .map { bool, count in
                if bool && count == 3 {
                    self.totalViewState = !self.totalViewState
                    return true
                } else if !bool && count == 2 {
                    self.totalViewState = !self.totalViewState
                    return false
                }
                return false
            }
            .eraseToAnyPublisher()
        
        let completeButtonResult = input.completeButtonTapped
            .handleEvents(receiveSubscription: { _ in
                self.loadingViewSubject.send(true)
            })
            .flatMap { _ -> AnyPublisher<[PopupBadge], Never> in
                return Future<[PopupBadge], Never> { promise in
                    // 온보딩 이탈 가능성 있기 때문에 clinetAccessToken 값 저장
                    OnboardingAPI.shared.serviceAcceptedPatch(param: ServiceAcceptRequest(username: self.nickname,
                                                                                          termAccepted: true),
                                                              accessToken: UserDefaultsManager.clientAccessToken) { result in
                        switch result {
                        case .success(let response):
                            UserDefaultsManager.accessToken = UserDefaultsManager.clientAccessToken
                            UserDefaultsManager.refreshToken = UserDefaultsManager.clientRefreshToken
                            promise(.success(response.badges))
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
        
        let errorResult = self.errorSubject.eraseToAnyPublisher()
        let loadingViewResult = self.loadingViewSubject.eraseToAnyPublisher()
        
        return Output(totalViewResult: totalViewResult,
                      cellResult: cellResult,
                      cellIndexResult: cellIndexResult,
                      totalViewStateResult: totalViewStateSubject,
                      completeButtonResult: completeButtonResult,
                      errorSubject: errorResult,
                      loadingViewSubject: loadingViewResult)
    }
}

extension ServiceAcceptViewModel {
    private func validateServiceAccept() -> SmeemButtonType {
        self.indexPathArray.contains(0) && self.indexPathArray.contains(1) ? .enabled : .notEnabled
    }
    
    private func setNotionUrl(indexPath: Int) -> URL {
        if indexPath == 0 {
            return URL(string: "https://smeem.notion.site/7132b91df0eb4838b435b53ad7cbb588?pvs=4")!
        } else if indexPath == 1 {
            return URL(string: "https://smeem.notion.site/334e225bb69b45c28f31fe363ca9f25e?pvs=4")!
        } else {
            return URL(string: "https://smeem.notion.site/793bae40ccd14654828b68ee41ac51b6")!
        }
    }
}
