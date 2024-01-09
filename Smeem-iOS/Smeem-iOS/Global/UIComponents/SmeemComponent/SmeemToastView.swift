//
//  SmeemToastView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/05/03.
//

/**
 1. 사용할 VC에서 SmeemToastView 생성 후 파라메터 안에 타입에 맞는 속성 선언
 let regExToastView = SmeemToastView(type: .smeemToast(bodyType: .regEx))
 let regExToastView = SmeemToastView(type: .errorToast(errorType: .networkError))
 
 2. func showToast(message: String) {
 saveToastView = SmeemToastView(type: .defaultToast(bodyType: .custom(message: message)))
 guard let toastView = saveToastView else { return }
 toastView.show(in: view, offset: 30, keyboardHeight: 0)
 toastView.hide(after: 3)
}
 **/

import UIKit

import SnapKit

enum ToastViewType: Error {
    case smeemToast(bodyType: SmeemToast)
    case smeemErrorToast(text: String)
    case networkErrorToast(message: String, body: String = "재접속하거나 나중에 다시 시도해 주세요")
    
    var displayText: (head: String?, body: String?) {
        switch self {
        case .smeemToast(bodyType: let bodyType):
            return (nil, bodyType.displayText)
        case .smeemErrorToast(let text):
            return (nil, text)
        case .networkErrorToast(let message, let bodyText):
            return (message, bodyText)
        }
    }
}

enum SmeemToast: String {
    case regEx = "외국어를 포함해 작성해 주세요 :("
    case completed = "작성 완료"
    case changed = "변경 완료"
    case edited = "첨삭 완료"
    case serverError = "로그인에 실패했어요. 다시 시도해 주세요."
    
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
        imageView.image = Constant.Image.icnToastError
        return imageView
    }()
    
    private let headLabel: UILabel = {
        let label = UILabel()
        label.font = .c1
        label.textColor = .smeemWhite
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .smeemWhite
        return label
    }()
    
    // MARK: - Life Cycle
    
    init(type: ToastViewType) {
        self.type = type
        switch type {
        case .smeemToast(bodyType: let bodyType):
            self.bodyText = bodyType.rawValue
        case .smeemErrorToast(let text):
            self.bodyText = text
        case .networkErrorToast(_, let text):
            self.bodyText = text
        }
        super.init(frame: .zero)
        alpha = 0
        setToastViewUI()
        setToastViewLayout()
        setLineHeight()
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
    
    private func setLineHeight() {
        headLabel.setTextWithLineHeight(lineHeight: 21)
        bodyLabel.setTextWithLineHeight(lineHeight: 14)
    }
    
    // MARK: - Layout
    
    private func setToastViewUI() {
        let (headText, bodyText) = type.displayText
        headLabel.text = headText
        bodyLabel.text = bodyText
        
        func lineHeight(for type: ToastViewType) -> CGFloat {
            switch type {
            case .smeemToast, .smeemErrorToast:
                return 22
            case .networkErrorToast:
                return 14
            }
        }
        
        switch self.type {
        case .smeemToast, .smeemErrorToast:
            backgroundColor = .toastBackground
            bodyLabel.font = .c2
            
        case .networkErrorToast:
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
        case .smeemToast, .smeemErrorToast:
            bodyLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().offset(convertByWidthRatio(16))
            }
        case .networkErrorToast:
            cautionImage.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalTo(convertByWidthRatio(19))
                make.width.height.equalTo(22)
            }
            
            headLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(14)
                make.leading.equalTo(cautionImage.snp.trailing).offset(14)
            }
            
            bodyLabel.snp.makeConstraints { make in
                make.top.equalTo(headLabel.snp.bottom).offset(3)
                make.leading.equalTo(headLabel)
            }
        }
        
        snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.width.equalTo(convertByWidthRatio(339))
            
            if case .smeemToast = type {
                make.height.equalTo(convertByHeightRatio(50))
            } else {
                make.height.equalTo(convertByHeightRatio(70))
            }
        }
    }
}

extension SmeemToastView {
    func show(in view: UIView, animated: Bool = true, hasKeyboard: Bool) {
        view.addSubview(self)
        
        snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            if hasKeyboard {
                make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-73)
            } else {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            }
        }
        
        if animated {
            alpha = 0
            UIView.animate(withDuration: 0.6) {
                self.alpha = 1
            }
        } else {
            alpha = 1
        }
    }
    
    func hide(after delay: TimeInterval, animated: Bool = true) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            if animated {
                UIView.animate(withDuration: 0.6, animations: {
                    self?.alpha = 0
                }, completion: { _ in
                    self?.removeFromSuperview()
                })
            } else {
                self?.removeFromSuperview()
            }
        }
    }
}

