//
//  ResignSummaryViewModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 7/9/24.
//

import Foundation
import Combine

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
    }
    
    struct Output {
        let viewWillAppearResult: AnyPublisher<[Goal], Never>
        let cellResult: AnyPublisher<String, Never>
    }
    
    func transform(input: Input) -> Output {
        let viewWillAppearResult = input.viewWillAppearSubject
            .map { _ -> [Goal] in
                return self.summaryData
            }
            .eraseToAnyPublisher()
        
        let cellResult = input.cellTapped
            .map { index -> String in
                return self.summaryData[index].name
            }
            .eraseToAnyPublisher()
            
        return Output(viewWillAppearResult: viewWillAppearResult,
                      cellResult: cellResult)
    }
}
