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
        static let icnCancelGrey = UIImage(named: "icnCancelGrey")
        static let icnCancelSmall = UIImage(named: "icnCancelSmall")
        static let icnCancelWhite = UIImage(named: "icnCancelWhite")
        static let icnCheck = UIImage(named: "icnCheck")
        static let icnCheckInactive = UIImage(named: "icnCheckInactive")
        static let icnMore = UIImage(named: "icnMore")
        static let icnMoreHoriz = UIImage(named: "icnMoreHoriz")
        static let incCheckActive = UIImage(named: "incCheckActive")
        static let icnMyPage = UIImage(named: "icnMyPage")
        static let icnRightArrow = UIImage(named: "icnRightArrow")
        static let noDiary = UIImage(named: "noDiary")
        static let monthday = UIImage(named: "monthday")
        static let monthToday = UIImage(named: "monthToday")
    }
}
