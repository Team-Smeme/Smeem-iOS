//
//  CustomToastView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/05/03.
//

/**
 1. 사용할 VC에서 CustomToastView 생성
 let toastView = CustomToastView(text: "토스트 메시지 텍스트")
 
 2. view에 addSubView 후 y축(bottom) 레이아웃 값만 입력해서 사용
 
 3. duration에 띄워지는 시간을 입력해서 호출 toastView.show(duration: )
**/

import UIKit

import SnapKit

final class CustomToastView: UIView {
    
    // MARK: - Property
    
    private let text: String
    
    // MARK: - UI Property
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .c2
        label.textColor = .smeemWhite
        label.setTextWithLineHeight(lineHeight: 17)
        label.sizeToFit()
        return label
    }()
    
    // MARK: - Life Cycle
    
    public init(text: String) {
        self.text = text
        super.init(frame: .zero)
        alpha = 0
        setToastViewUI()
        setToastViewLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    public func show(duration: TimeInterval) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
        })
        UIView.animate(withDuration: 0.3, delay: duration, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    // MARK: - Layout
    
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
            $0.leading.equalToSuperview().offset(convertByWidthRatio(16))
        }
        
        snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.width.equalTo(convertByWidthRatio(339))
            $0.height.equalTo(convertByHeightRatio(50))
        }
    }
}
