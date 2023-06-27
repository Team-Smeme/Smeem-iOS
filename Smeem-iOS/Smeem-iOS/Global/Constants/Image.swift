//
//  Image.swift
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
        static let icnCheckActive = UIImage(named: "icnCheckActive")
        static let icnMyPage = UIImage(named: "icnMyPage")
        static let icnRightArrow = UIImage(named: "icnRightArrow")
        static let noDiary = UIImage(named: "noDiary")
        static let monthday = UIImage(named: "monthday")
        static let monthToday = UIImage(named: "monthToday")
        
        static let logoWhiteSmeem = UIImage(named: "logoWhiteSmeem")
        static let logoPointSmeem = UIImage(named: "logoPointSmeem")
        
        static let tutorialWeekly = UIImage(named: "tutorialWeekly")
        static let tutorialWeeklyCorrection = UIImage(named: "tutorialWeeklyCorrection")
        static let tutorialDiaryStepOne = UIImage(named: "tutorialDiaryStepOne")
        static let tutorialDiaryStepTwo = UIImage(named: "tutorialDiaryStepTwo")
        
        static let btnAppleLogin = UIImage(named: "btnAppleLogin")
        static let btnKakaoLogin = UIImage(named: "btnKakaoLogin")
        static let btnNonMember = UIImage(named: "btnNonMember")
    }
}
