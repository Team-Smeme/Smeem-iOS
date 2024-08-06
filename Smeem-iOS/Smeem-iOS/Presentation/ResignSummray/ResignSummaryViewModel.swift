//
//  ResignSummaryViewModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 7/9/24.
//

import Foundation
import Combine

import KakaoSDKUser

struct KeyboardInfo {
    let type: KeyboardType
    let keyboardHeight: CGFloat?
    let viewHeight: CGFloat?
}

enum KeyboardType {
    case up
    case down
}

enum ResignAmplitudeType {
    case deleteIdTry
    case deleteIdComplete
}

final class ResignSummaryViewModel: ViewModel {
    
    var provider: AuthServiceProtocol!
    
    init(provider: AuthServiceProtocol) {
        self.provider = provider
    }
    
    private let summaryData: [Goal] = [Goal(goalType: nil, name: "이용이 어렵고 서비스가 불안정해요."),
                                       Goal(goalType: nil, name: "일기 작성을 도와주는 기능이 부족해요."),
                                       Goal(goalType: nil, name: "일기 쓰기가 귀찮아요."),
                                       Goal(goalType: nil, name: "다른 앱이 더 사용하기 편해요."),
                                       Goal(goalType: nil, name: "기타 의견")]
    private let summaryTypeDic: [Int:String] = [0: "INSTABILITY",
                                                1: "LACK",
                                                2: "BOTHER",
                                                3: "COMPARISON",
                                                4: "ETC"]
    private var summaryType: String? = nil
    
    struct Input {
        let viewWillAppearSubject: PassthroughSubject<Void, Never>
        let cellTapped: PassthroughSubject<Int, Never>
        let buttonTapped: PassthroughSubject<Void, Never>
        let keyboardSubject: PassthroughSubject<KeyboardType, Never>
        let keyboardHeightSubject: PassthroughSubject<KeyboardInfo, Never>
        let summaryTextSubject: PassthroughSubject<String, Never>
    }
    
    struct Output {
        let viewWillAppearResult: AnyPublisher<[Goal], Never>
        let keyboardResult: AnyPublisher<CGFloat, Never>
        let enabledButtonResult: PassthroughSubject<SmeemButtonType, Never>
        let notEnabledButtonResult: PassthroughSubject<SmeemButtonType, Never>
        let errorResult: AnyPublisher<SmeemError, Never>
        let resignResult: AnyPublisher<Void, Never>
    }
    
    private let cellIndexSubject = PassthroughSubject<Int, Never>()
    private let enabledButtonResult = PassthroughSubject<SmeemButtonType, Never>()
    private let notEnabledButtonResult = PassthroughSubject<SmeemButtonType, Never>()
    private let resignSubject = PassthroughSubject<Void, Never>()
    private let errorSubject = PassthroughSubject<SmeemError, Never>()
    private let amplitudeSubject = PassthroughSubject<ResignAmplitudeType, Never>()
    private var keyboardHeight = 0.0
    private var cancelBag = Set<AnyCancellable>()
    private var totalViewHeight: CGFloat = 0.0
    private var summaryText: String? = ""
    
    func transform(input: Input) -> Output {
        let viewWillAppearResult = input.viewWillAppearSubject
            .map { _ -> [Goal] in
                return self.summaryData
            }
            .eraseToAnyPublisher()
        
        amplitudeSubject.sink { type in
            switch type {
            case .deleteIdTry:
                AmplitudeManager.shared.track(event: AmplitudeConstant.myPage.delete_id_try.event)
            case .deleteIdComplete:
                AmplitudeManager.shared.track(event: AmplitudeConstant.myPage.delete_id_done.event)
            }
        }
        .store(in: &cancelBag)
        
        input.cellTapped
            .sink { index in
                self.summaryType = self.summaryTypeDic[index]!
                self.cellIndexSubject.send(index)
            }
            .store(in: &cancelBag)
        
        cellIndexSubject
            .sink { index -> Void in
                if index == 4 && self.summaryText == "" { self.notEnabledButtonResult.send(.notEnabled) }
                else { self.enabledButtonResult.send(.enabled) }
            }
            .store(in: &cancelBag)
        
        let keyboardResult = input.keyboardHeightSubject
            .map { info -> CGFloat in
                if let viewHeight = info.viewHeight { self.totalViewHeight = viewHeight }
                return info.type == .up ? self.totalViewHeight-info.keyboardHeight! : self.totalViewHeight
            }
            .eraseToAnyPublisher()
        
        input.summaryTextSubject
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines ) }
            .sink { text -> Void in
                self.summaryText = text
                if text.isEmpty {
                    self.notEnabledButtonResult.send(.notEnabled)
                } else {
                    self.enabledButtonResult.send(.enabled)
                }
            }
            .store(in: &cancelBag)
        
        func kakaoResignAPI() {
            UserApi.shared.unlink { (error) in
                if let _ = error {
                    self.errorSubject.send(.clientError)
                }
                else {
                    print("unlink() success.")
                    self.resignSubject.send(())
                }
            }
            
            self.resignSubject.send(())
        }
        
        input.buttonTapped
            .sink { _ in
                if UserDefaultsManager.hasKakaoToken! {
                    kakaoResignAPI()
                } else {
                    self.resignSubject.send(())
                }
            }
            .store(in: &cancelBag)
        
        let resignResult = resignSubject
            .flatMap { _ -> AnyPublisher<Void, Never> in
                return Future<Void, Never> { promise in
                    self.provider.resignAPI(request: ResignRequest(withdrawType: self.summaryType!,
                                                                   reason: self.summaryText)) { result in
                        self.amplitudeSubject.send(.deleteIdTry)
                        switch result {
                        case .success(_):
                            UserDefaultsManager.accessToken = ""
                            UserDefaultsManager.refreshToken = ""
                            UserDefaultsManager.clientAccessToken = ""
                            UserDefaultsManager.clientRefreshToken = ""
                            UserDefaultsManager.hasKakaoToken = nil
                            self.amplitudeSubject.send(.deleteIdComplete)
                            promise(.success(()))
                        case .failure(let error):
                            self.errorSubject.send(error)
                        }
                    }
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        let errorResult = errorSubject.eraseToAnyPublisher()
            
        return Output(viewWillAppearResult: viewWillAppearResult,
                      keyboardResult: keyboardResult,
                      enabledButtonResult: enabledButtonResult,
                      notEnabledButtonResult: notEnabledButtonResult,
                      errorResult: errorResult,
                      resignResult: resignResult)
    }
}
