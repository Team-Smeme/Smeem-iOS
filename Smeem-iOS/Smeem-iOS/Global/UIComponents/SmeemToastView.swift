//
//  SmeemToastView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/05/03.
//

/**
 1. 사용할 VC에서 SmeemToastView 생성
 let toastView = SmeemToastView(text: "토스트 메시지 텍스트")
 
 2. view에 addSubView 후 y축(bottom) 레이아웃 값만 입력해서 사용
 
 3. duration에 띄워지는 시간을 입력해서 호출 toastView.show(duration: )
 **/

import UIKit

import SnapKit

enum ToastViewType {
    case defaultToast(bodyType: BodyType)
    case errorToast(errorType: ErrorType)
    
    var displayText: (head: String?, body: String) {
        switch self {
        case .defaultToast(bodyType: let bodyType):
            return (nil, bodyType.displayText)
        case .errorToast(errorType: let errorType):
            return (errorType.displayText, BodyType.error.displayText)
        }
    }
}

enum ErrorType: String {
    case networkError = "인터넷 연결을 확인해 주세요 :("
    case systemError = "죄송합니다, 시스템 오류가 발생했어요 :("
    case loadDataError = "데이터를 불러올 수 없어요 :("
    
    var displayText: String {
        return self.rawValue
    }
}

enum BodyType: String {
    case error = "재접속하거나 나중에 다시 시도해 주세요."
    case regEx = "외국어를 포함해 작성해 주세요 :("
    case completed = "작성 완료"
    case changed = "변경 완료"
    case edited = "첨삭 완료"
    
    var displayText: String {
        return self.rawValue
    }
}

final class SmeemToastView: UIView {
    
    // MARK: - Property
    
    private let type: ToastViewType
    private let bodyText: String
    
    // MARK: - UI Property
    
    private let cautionImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        return imageView
    }()
    
    private let headLabel: UILabel = {
        let label = UILabel()
        label.font = .c1
        label.textColor = .smeemWhite
        label.setTextWithLineHeight(lineHeight: 21)
        label.sizeToFit()
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .smeemWhite
        label.setTextWithLineHeight(lineHeight: 17)
        label.sizeToFit()
        return label
    }()
    
    // MARK: - Life Cycle
    
    public init(type: ToastViewType) {
        self.type = type
        switch type {
        case .defaultToast(bodyType: let bodyType):
            self.bodyText = bodyType.rawValue
        case .errorToast:
            self.bodyText = BodyType.error.rawValue
            
        }
        super.init(frame: .zero)
        alpha = 0
        setToastViewUI()
        setToastViewLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    public func show(duration: TimeInterval = 0.7) {
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
        let (headText, bodyText) = type.displayText
        headLabel.text = headText
        bodyLabel.text = bodyText
        
        switch type {
        case .defaultToast:
            bodyLabel.font = .c2
        case .errorToast:
            bodyLabel.font = .c4
        }
        
        backgroundColor = .toastBackground
        clipsToBounds = true
        layer.cornerRadius = 6
    }
    
    
    private func setToastViewLayout() {
        addSubviews(cautionImage, headLabel, bodyLabel)
        
        switch type {
        case .defaultToast:
            bodyLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(convertByWidthRatio(16))
            }
            
        case .errorToast:
            
            cautionImage.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalTo(convertByWidthRatio(19))
                $0.width.height.equalTo(22)
            }
            
            headLabel.snp.makeConstraints {
                $0.top.equalToSuperview().offset(14)
                $0.leading.equalTo(cautionImage.snp.trailing).offset(14)
            }
            
            bodyLabel.snp.makeConstraints {
                $0.top.equalTo(headLabel.snp.bottom).offset(3)
                $0.leading.equalTo(headLabel)
            }
        }
        
        snp.makeConstraints {
            $0.centerX.equalTo(self)
            $0.width.equalTo(convertByWidthRatio(339))
            
            if case .defaultToast = type {
                $0.height.equalTo(convertByHeightRatio(50))
            } else {
                $0.height.equalTo(convertByHeightRatio(70))
            }
        }
    }
}
