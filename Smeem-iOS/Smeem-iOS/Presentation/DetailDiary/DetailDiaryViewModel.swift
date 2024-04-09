//
//  DetailDiaryViewModel.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2024/04/08.
//

import Foundation
import Combine

final class DetailDiaryViewModel: ViewModel {
    struct Input {
        let leftButtonTapped: PassthroughSubject<Void, Never>
        let rightButtonTapped: PassthroughSubject<Void, Never>
    }
    
    struct Output {
        let leftButtonAction: AnyPublisher<Void, Never>
        let rightButtonAction: AnyPublisher<Void, Never>
    }
    
    private var cancelBag = Set<AnyCancellable>()
    
    func transform(input: Input) -> Output {
        let leftButtonAction = input.leftButtonTapped
            .eraseToAnyPublisher()
        
        let rightButtonAction = input.rightButtonTapped
            .eraseToAnyPublisher()
        
        return Output(leftButtonAction: leftButtonAction,
                      rightButtonAction: rightButtonAction)
    }
}
