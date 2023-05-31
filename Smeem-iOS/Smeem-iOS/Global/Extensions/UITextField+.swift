//
//  UITextField+.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/20.
//

import UIKit

extension UITextField {
    func addPaddingView() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
