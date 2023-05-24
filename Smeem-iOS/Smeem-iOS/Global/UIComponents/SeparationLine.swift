//
//  SeparationLine.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/05/02.
//

//import UIKit
//
//import SnapKit
//
//enum LineHeight: CGFloat {
//    case thin = 1
//    case thick = 6
//}
//
//class SeparationLine: UIView {
//    var height: LineHeight
//
//    convenience init(height: LineHeight) {
//        self.init(height: height)
//        self.height = height
//        self.backgroundColor = height == .thin ? UIColor.gray100 : UIColor.gray200
//
//        snp.makeConstraints { make in
//            make.height.equalTo(height.rawValue)
//        }
//    }
//}

import UIKit
import SnapKit

class SeparationLine: UIView {
    enum LineHeight: CGFloat {
        case thin = 1
        case thick = 6
    }
    
    var height: LineHeight
    
    convenience init() {
        self.init(height: .thin)
    }
    
    init(height: LineHeight) {
        self.height = height
        super.init(frame: .zero)
        self.backgroundColor = height == .thin ? UIColor.gray100 : UIColor.gray200
        
        snp.makeConstraints {
            $0.height.equalTo(height.rawValue)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


