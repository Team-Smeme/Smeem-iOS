//
//  Navigatable.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/09/09.
//

import UIKit

protocol Navigatable {
    func setLeftButtonAction(_ action: @escaping () -> Void)
    func setRightButtonAction(_ action: @escaping () -> Void)
}
