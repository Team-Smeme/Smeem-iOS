//
//  DelegateSetupStrategy.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/11/02.
//

import Foundation

protocol DelegateSetupStrategy {
    func setupDelegate(for viewController: DiaryViewController)
}

class DefaultDelegateSeupStrategy: DelegateSetupStrategy {
    func setupDelegate(for viewController: DiaryViewController) {
        viewController.setNagivationBarDelegate()
    }
}
