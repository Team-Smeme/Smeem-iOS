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

enum NetworkError: Error {
    case networkError
    case systemError
    case loadDataError
    case urlEncodingError
    case jsonDecodingError
    case unAuthorizedError
    case unknownError(message: String)
    case jsonEncodingError
    case typeCastingError
}

enum SmeemToast: String {
    case error = "임쉬에러"
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
        //TODO: 추후 추가할게요!
        imageView.image = Constant.Image.icnToastError
        return imageView
    }()
    
    private let headLabel: UILabel = {
        let label = UILabel()
        label.font = .c1
        label.textColor = .smeemWhite
        //TODO: 미리 속성지정 없이도 lineHeight 적용되게 하기
        label.setTextWithLineHeight(lineHeight: 21)
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .smeemWhite
        //TODO: 미리 속성지정 없이도 lineHeight 적용되게 하기
        label.setTextWithLineHeight(lineHeight: 14)
        return label
    }()
    
    // MARK: - Life Cycle
    
    public init(type: ToastViewType) {
        self.type = type
        switch type {
        case .smeemToast(bodyType: let bodyType):
            self.bodyText = bodyType.rawValue
        case .smeemErrorToast(let text):
            self.bodyText = text
        case .networkErrorToast:
            self.bodyText = SmeemToast.error.rawValue
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
            bodyLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(convertByWidthRatio(16))
            }
        case .networkErrorToast:
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
            
            if case .smeemToast = type {
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
            UIView.animate(withDuration: 0.6) {
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
                UIView.animate(withDuration: 0.6, animations: {
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

