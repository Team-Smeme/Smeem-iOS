//
//  ViewModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2024/01/28.
//

import Foundation

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
