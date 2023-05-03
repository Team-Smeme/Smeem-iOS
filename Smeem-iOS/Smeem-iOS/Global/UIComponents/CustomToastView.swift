//
//  CustomToastView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/05/03.
//

import UIKit

class CustomToastView: UIView {
    private let label = UILabel()
    private let text: String
    
    public init(text: String) {
        self.text = text
        super.init(frame: .zero)
        setToastViewUI()
        setToastViewLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show(duration: TimeInterval, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: duration, animations: {
                self.alpha = 0
            }) { _ in
                self.removeFromSuperview()
                completion?()
            }
        }
    }
}

extension CustomToastView {
    private func setToastViewUI() {
        addSubview(label)
        label.font = .c2
        label.textColor = .smeemWhite
        label.text = text
        label.sizeToFit()
        backgroundColor = .toastBackground
        layer.cornerRadius = 6
        clipsToBounds = true
    }
    
    private func setToastViewLayout() {
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
        snp.makeConstraints {
            $0.width.equalTo(339)
            $0.height.equalTo(50)
        }
    }
}
