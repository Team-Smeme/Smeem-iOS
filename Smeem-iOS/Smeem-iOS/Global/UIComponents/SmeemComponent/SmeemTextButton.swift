//
//  SmeemTextButton.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/10/10.
//

import UIKit

final class SmeemTextButton: UIButton {
    
    init(title: String, textColor: UIColor, font: UIFont) {
        super.init(frame: .zero)
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.titleLabel?.font = font
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
