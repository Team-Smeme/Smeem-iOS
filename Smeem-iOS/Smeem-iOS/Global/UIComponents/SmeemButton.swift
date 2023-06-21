//
//  SmeemButton.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/02.
//

import UIKit

enum SmeemButtonType {
    case notEnabled
    case enabled
}

final class SmeemButton: UIButton {
    
    var smeemButtonType: SmeemButtonType = .notEnabled {
        didSet {
            setButtonStyle()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setButtonStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButtonStyle() {
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = .s1
        self.layer.cornerRadius = 6
        self.titleLabel?.textAlignment = .center
        
        switch smeemButtonType {
        case .notEnabled:
            self.backgroundColor = .pointInactive
            self.isEnabled = false
        case .enabled:
            self.backgroundColor = .point
            self.isEnabled = true
        }
    }
}
