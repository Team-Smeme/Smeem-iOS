//
//  ViewModel.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 11/18/24.
//

import Foundation

protocol Store {
    associatedtype Action
    associatedtype State
    
    var state: State { get }
    @MainActor
    func send(action: Action)
}
