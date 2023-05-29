//
//  SeparationLine.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/05/02.
//

/**
 1. 사용할 VC에서 SeparationLine 프로퍼티 생성
 pivate let mediumLine = SeparationLine(height: .medium)
 
 2. view에 addSubView 하고 y축(top)값만 설정
 **/

import UIKit

import SnapKit

class SeparationLine: UIView {
    
    // MARK: - UI Property
    
    enum LineHeight: CGFloat {
        case thin = 1
        case medium = 2
        case thick = 6
    }
    
    private let thinLineColor = UIColor.gray100
    private let thickLineColor = UIColor.gray200
    
    private let height: LineHeight
    
    // MARK: - Life Cycle
    
    convenience init() {
        self.init(height: .thin)
    }
    
    init(height: LineHeight) {
        self.height = height
        super.init(frame: .zero)
        setColors()
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom method
    
    private func setColors() {
        switch height {
        case .thin, .medium:
            self.backgroundColor = thinLineColor
        case .thick:
            self.backgroundColor = thickLineColor
        }
    }
    
    private func setLayout() {
        snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(height.rawValue)
        }
    }
}
