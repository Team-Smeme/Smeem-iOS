//
//  ResignSummaryViewModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 7/9/24.
//

import Foundation
import Combine

struct KeyboardInfo {
    let type: KeyboardType
    let keyboardHeight: CGFloat?
    let viewHeight: CGFloat?
}

enum KeyboardType {
    case up
    case down
}

final class ResignSummaryViewModel: ViewModel {
    
    private let summaryData: [Goal] = [Goal(goalType: nil, name: "이용이 어렵고 서비스가 불안정해요."),
                                       Goal(goalType: nil, name: "일기 작성을 도와주는 기능이 부족해요."),
                                       Goal(goalType: nil, name: "일기 쓰기가 귀찮아요."),
                                       Goal(goalType: nil, name: "다른 앱이 더 사용하기 편해요."),
                                       Goal(goalType: nil, name: "기타 의견")]
    
    struct Input {
        let viewWillAppearSubject: PassthroughSubject<Void, Never>
        let cellTapped: PassthroughSubject<Int, Never>
        let buttonTapped: PassthroughSubject<Void, Never>
        let keyboardSubject: PassthroughSubject<KeyboardType, Never>
        let keyboardHeightSubject: PassthroughSubject<KeyboardInfo, Never>
    }
    
    struct Output {
        let viewWillAppearResult: AnyPublisher<[Goal], Never>
        let cellResult: AnyPublisher<String, Never>
        let buttonResult: AnyPublisher<SmeemButtonType, Never>
        let keyboardResult: AnyPublisher<CGFloat, Never>
        let enabledButtonResult: PassthroughSubject<SmeemButtonType, Never>
        let notEnabledButtonResult: PassthroughSubject<SmeemButtonType, Never>
    }
    
    private let cellIndexSubject = PassthroughSubject<Int, Never>()
    private let enabledButtonResult = PassthroughSubject<SmeemButtonType, Never>()
    private let notEnabledButtonResult = PassthroughSubject<SmeemButtonType, Never>()
    private var keyboardHeight = 0.0
    private var cancelBag = Set<AnyCancellable>()
    private var totalViewHeight: CGFloat = 0.0
    
    func transform(input: Input) -> Output {
        let viewWillAppearResult = input.viewWillAppearSubject
            .map { _ -> [Goal] in
                return self.summaryData
            }
            .eraseToAnyPublisher()
        
        let cellResult = input.cellTapped
            .map { index -> String in
                self.cellIndexSubject.send(index)
                return self.summaryData[index].name
            }
            .eraseToAnyPublisher()
        
        let buttonResult = cellIndexSubject
            .map { index -> SmeemButtonType in
                return index == 4 ? .notEnabled : .enabled
            }
            .eraseToAnyPublisher()
        
        cellIndexSubject
            .sink { index -> Void in
                if index == 4 { self.notEnabledButtonResult.send(.notEnabled) }
                else { self.enabledButtonResult.send(.enabled) }
            }
            .store(in: &cancelBag)
        
        let keyboardResult = input.keyboardHeightSubject
            .map { info -> CGFloat in
                if let viewHeight = info.viewHeight { self.totalViewHeight = viewHeight }
                return info.type == .up ? self.totalViewHeight-info.keyboardHeight! : self.totalViewHeight
            }
            .eraseToAnyPublisher()
            
        return Output(viewWillAppearResult: viewWillAppearResult,
                      cellResult: cellResult,
                      buttonResult: buttonResult,
                      keyboardResult: keyboardResult,
                      enabledButtonResult: enabledButtonResult,
                      notEnabledButtonResult: notEnabledButtonResult)
    }
}
