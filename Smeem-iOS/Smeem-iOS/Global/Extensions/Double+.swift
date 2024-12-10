//
//  Double+.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 12/1/24.
//

import UIKit

extension Double {
    // 너비 기반 스케일링 (iPhone 13 mini)
    func scaledByWidth() -> Double {
        return (self / 375) * UIScreen.main.bounds.width
    }
    
    // 높이 기반 스케일링 (iPhone 13 mini)
    func scaledByHeight() -> Double {
        return (self / 812) * UIScreen.main.bounds.height
    }
}
