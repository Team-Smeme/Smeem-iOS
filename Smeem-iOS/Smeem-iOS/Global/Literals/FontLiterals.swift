//
//  FontLiterals.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/05/01.
//

import UIKit

extension UIFont {
    @nonobjc class var h1: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 26)
    }
    
    @nonobjc class var h2: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 24)
    }
    
    @nonobjc class var h3: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 20)
    }
    
    @nonobjc class var s1: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 18)
    }
    
    @nonobjc class var s2: UIFont {
        return UIFont.font(.pretendardSemiBold, ofSize: 18)
    }
    
    @nonobjc class var s3: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 18)
    }
    
    @nonobjc class var s4: UIFont {
        return UIFont.font(.pretendardRegular, ofSize: 18)
    }
    
    @nonobjc class var b1: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 16)
    }
    
    @nonobjc class var b2: UIFont {
        return UIFont.font(.pretendardSemiBold, ofSize: 16)
    }
    
    @nonobjc class var b3: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 16)
    }
    
    @nonobjc class var b4: UIFont {
        return UIFont.font(.pretendardRegular, ofSize: 16)
    }
    
    @nonobjc class var c1: UIFont {
        return UIFont.font(.pretendardBold, ofSize: 14)
    }
    
    @nonobjc class var c2: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 14)
    }
    
    @nonobjc class var c3: UIFont {
        return UIFont.font(.pretendardRegular, ofSize: 14)
    }
    
    @nonobjc class var c4: UIFont {
        return UIFont.font(.pretendardRegular, ofSize: 12)
    }
    
    @nonobjc class var c5: UIFont {
        return UIFont.font(.pretendardSemiBold, ofSize: 12)
    }
    
    @nonobjc class var c6: UIFont {
        return UIFont.font(.pretendardMedium, ofSize: 9)
    }
    
    @nonobjc class var u1: UIFont {
        return UIFont.font(.urbanistSemiBold, ofSize: 28)
    }
}

enum FontName: String {
    case pretendardBold = "Pretendard-Bold"
    case pretendardSemiBold = "Pretendard-SemiBold"
    case pretendardMedium = "Pretendard-Medium"
    case pretendardRegular = "Pretendard-Regular"
    case urbanistSemiBold = "Urbanist-SemiBold"
}

extension UIFont {
    static func font(_ style: FontName, ofSize size: CGFloat) -> UIFont {
        return UIFont(name: style.rawValue, size: size)!
    }
}

