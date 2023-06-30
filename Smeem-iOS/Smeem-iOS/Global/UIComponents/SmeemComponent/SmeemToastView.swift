//
//  SmeemToastView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/05/03.
//

/**
 1. 사용할 VC에서 SmeemToastView 생성 후 파라메터 안에 타입에 맞는 속성 선언
 let regExToastView = SmeemToastView(type: .defaultToast(bodyType: .regEx))
 let regExToastView = SmeemToastView(type: .errorToast(errorType: .networkError))
 
 2. view에 addSubView 후 y축(bottom) 레이아웃 값만 입력해서 사용
 
 
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
        //TODO: 추후 추가할게요!
        imageView.backgroundColor = .white
        return imageView
    }()
    
    private let headLabel: UILabel = {
        let label = UILabel()
        label.font = .c1
        label.textColor = .smeemWhite
        //TODO: 미리 속성지정 없이도 lineHeight 적용되게 하기
        label.text = "추후 수정하겠습니다.."
        label.setTextWithLineHeight(lineHeight: 21)
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .smeemWhite
        //TODO: 미리 속성지정 없이도 lineHeight 적용되게 하기
        label.text = "추후 수정하겠습니다.."
        label.setTextWithLineHeight(lineHeight: 14)
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
    
    //    public func show(duration: TimeInterval = 0.7) {
    //        UIView.animate(withDuration: 0.3, animations: {
    //            self.alpha = 1
    //        })
    //        UIView.animate(withDuration: 0.3, delay: duration, animations: {
    //            self.alpha = 0
    //        }) { _ in
    //            self.removeFromSuperview()
    //        }
    //    }
    
    // MARK: - Layout
    
    private func setToastViewUI() {
        let (headText, bodyText) = type.displayText
        headLabel.text = headText
        bodyLabel.text = bodyText
        func lineHeight(for type: ToastViewType) -> CGFloat {
            switch type {
            case .defaultToast:
                return 22
            case .errorToast:
                return 14
            }
        }
        
        switch self.type {
        case .defaultToast:
            backgroundColor = .toastBackground
            bodyLabel.font = .c2
            
        case .errorToast:
            backgroundColor = .smeemBlack
            bodyLabel.font = .c4
        }
        
        let determinedLineHeight = lineHeight(for: self.type)
        
        bodyLabel.text = bodyText
        bodyLabel.setTextWithLineHeight(lineHeight: determinedLineHeight)
        
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

extension SmeemToastView {
    func show(in view: UIView, offset: CGFloat, keyboardHeight: CGFloat, animated: Bool = true) {
        view.addSubview(self)
        
        snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.snp.bottom).offset(-offset - keyboardHeight)
        }
        
        if animated {
            alpha = 0
            UIView.animate(withDuration: 0.3) {
                self.alpha = 1
            }
        } else {
            alpha = 1
        }
    }
    
    func hide(after delay: TimeInterval, animated: Bool = true) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }
            
            if animated {
                UIView.animate(withDuration: 0.3, animations: {
                    self.alpha = 0
                }, completion: { _ in
                    self.removeFromSuperview()
                })
            } else {
                self.removeFromSuperview()
            }
        }
    }
}

