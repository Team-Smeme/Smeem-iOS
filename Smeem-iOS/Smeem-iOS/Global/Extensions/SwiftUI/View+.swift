//
//  View+.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2024/10/16.
//

import SwiftUI

extension View {
    var screenSize: CGRect {
        return UIScreen.main.bounds
    }
    
    var screenHeight: Double {
      return screenSize.height
    }
    
    var screenWidth: Double {
        return screenSize.width
    }
}
