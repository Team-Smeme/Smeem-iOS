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
    init(buttonType: SmeemButtonType, text: String) {
        super.init(frame: .zero)
        
        self.setTitle(text, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = .s1
        self.layer.cornerRadius = 6
        self.titleLabel?.textAlignment = .center
        
        changeButtonType(buttonType: buttonType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeButtonType(buttonType: SmeemButtonType) {
        switch buttonType {
        case .notEnabled:
            self.backgroundColor = .pointInactive
            self.isEnabled = false
        case .enabled:
            self.backgroundColor = .point
            self.isEnabled = true
        }
    }
}
