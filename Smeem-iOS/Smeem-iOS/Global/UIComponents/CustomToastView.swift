//
//  CustomToastView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/05/03.
//

import UIKit

import SnapKit

class CustomToastView: UIView {
    
    private let text: String
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .c2
        label.textColor = .smeemWhite
        label.setTextWithLineHeight(lineHeight: 17)
        label.sizeToFit()
        return label
    }()
    
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
        })
        UIView.animate(withDuration: 0.3, delay: duration, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
            completion?()
        }
    }
}

extension CustomToastView {
    private func setToastViewUI() {
        backgroundColor = .toastBackground
        clipsToBounds = true
        layer.cornerRadius = 6
        
        label.text = text
    }
    
    private func setToastViewLayout() {
        addSubview(label)
        
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
