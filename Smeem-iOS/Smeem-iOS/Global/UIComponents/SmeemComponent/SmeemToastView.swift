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
    case smeemErrorToast(message: SmeemError, body: String = "재접속하거나 나중에 다시 시도해 주세요")
    
    var displayText: (head: String?, body: String?) {
        switch self {
        case .smeemToast(bodyType: let bodyType):
            return (nil, bodyType.displayText)
        case .smeemErrorToast(let message, let bodyText):
            return (message.displayText, bodyText)
        }
    }
}

enum SmeemToast: String {
    case regEx = "외국어를 포함해 작성해 주세요 :("
    case regExKr = "한국어를 포함해 작성해 주세요 :("
    case completed = "오늘의 일기 클리어!"
    case changed = "변경 완료"
    case edited = "첨삭 완료"
    case serverError = "로그인에 실패했어요. 다시 시도해 주세요."
    
    var displayText: String {
        return self.rawValue
    }
}

enum SmeemError: Error {
    case userError
    case clientError
    case serverError
    
    var displayText: String {
        switch self {
        case .userError:
            return "인터넷 연결을 확인해 주세요 :("
        case .clientError:
            return "죄송합니다, 시스템 오류가 발생했어요 :("
        case .serverError:
            return "데이터를 불러올 수 없어요 :("
        }
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
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 3
        stackView.alignment = .leading
        return stackView
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
        case .smeemErrorToast(let body, _):
            self.bodyText = body.displayText
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
            case .smeemToast:
                return 22
            case .smeemErrorToast:
                return 14
            }
        }
        
        switch self.type {
        case .smeemToast:
            backgroundColor = .toastBackground
            bodyLabel.font = .c2
            
        case .smeemErrorToast:
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
        addSubviews(cautionImage, labelStackView)
        labelStackView.addArrangedSubviews(headLabel, bodyLabel)
        
        switch type {
        case .smeemToast:
            bodyLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().offset(convertByWidthRatio(16))
            }
        case .smeemErrorToast:
            cautionImage.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalTo(convertByWidthRatio(19))
                make.width.height.equalTo(22)
            }
            
            labelStackView.snp.makeConstraints { make in
                make.leading.equalTo(cautionImage.snp.trailing).offset(14)
                make.centerY.equalTo(cautionImage)
            }
        }
        
        snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.width.equalTo(convertByWidthRatio(339))
            
            if case .smeemToast = type {
                make.height.equalTo(convertByHeightRatio(50))
            } else {
                make.height.equalTo(convertByWidthRatio(70))
            }
        }
    }
}

extension SmeemToastView {
    func show(in view: UIView, animated: Bool = true, hasKeyboard: Bool, height: CGFloat = 0.0) {
        view.addSubview(self)
        
        snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            if hasKeyboard {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-(height+40))
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

