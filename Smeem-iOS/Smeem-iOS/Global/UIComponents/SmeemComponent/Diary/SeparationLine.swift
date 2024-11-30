//
//  SeparationLine.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/05/02.
//

/**
 1. 사용할 VC에서 SeparationLine 프로퍼티 생성
    - 원하는 높이값은 UI Property -> LineHeight 참고
 
 pivate let mediumLine = SeparationLine(height: .medium)
 
 2. view에 addSubView 하고 y축(top)값과 centerX값 설정
 **/

import UIKit

import SnapKit

// MARK: - SeparationLine

final class SeparationLine: UIView {
    
    // MARK: UI Properties
    
    enum LineHeight: CGFloat {
        case thin = 1
        case medium = 2
        case thick = 6
    }
    
    private let thinLineColor = UIColor.gray200
    private let thickLineColor = UIColor.gray100
    
    private let height: LineHeight
    
    // MARK: Life Cycle
    
    init(height: LineHeight = .thin) {
        self.height = height
        super.init(frame: .zero)
        setColors()
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extension: Attributes

extension SeparationLine {
    private func setColors() {
        switch height {
        case .thin:
            self.backgroundColor = thinLineColor
        case .medium,.thick:
            self.backgroundColor = thickLineColor
        }
    }
    
    private func setLayout() {
        snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(height.rawValue)
        }
    }
}

// MARK: - Extension

extension SeparationLine {
    static func createThickLine() -> UIView {
        return SeparationLine(height: .thick)
    }
}
