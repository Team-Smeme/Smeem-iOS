//
//  ConstantImage.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/05/01.
//

import UIKit

struct Constant {
    private init() {}
}

extension Constant {
    enum Image {
        
        static let icnBack = UIImage(named: "icnBack")
        static let icnCancelBlack = UIImage(named: "icnCancelBlack")
        static let icnCancelGrey = UIImage(named: "icnCancelGrey")
        static let icnCancelSmall = UIImage(named: "icnCancelSmall")
        static let icnCancelWhite = UIImage(named: "icnCancelWhite")
        static let icnCheck = UIImage(named: "icnCheck")
        static let icnCheckInactive = UIImage(named: "icnCheckInactive")
        static let icnMore = UIImage(named: "icnMore")
        static let icnMoreHoriz = UIImage(named: "icnMoreHoriz")
        static let incCheckActive = UIImage(named: "incCheckActive")
    }
}
