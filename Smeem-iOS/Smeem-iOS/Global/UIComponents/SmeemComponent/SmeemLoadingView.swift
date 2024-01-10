//
//  SmeemLoadingView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/09/06.
//

import UIKit

final class SmeemLoadingView: UIActivityIndicatorView {
    
    init() {
        super.init(frame: .zero)
        self.style = .large
        self.backgroundColor = .popupBackground
        self.frame = .init(x: 0, y: 0, width: Constant.Screen.width, height: Constant.Screen.height)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
