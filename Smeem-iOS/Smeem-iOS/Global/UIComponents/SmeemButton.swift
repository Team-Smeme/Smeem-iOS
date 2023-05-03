//
//  SmeemButton.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/02.
//

import UIKit

final class SmeemButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setButtonStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButtonStyle() {
        self.backgroundColor = .point
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = .s1
        self.layer.cornerRadius = 6
        self.titleLabel?.textAlignment = .center
    }
}
