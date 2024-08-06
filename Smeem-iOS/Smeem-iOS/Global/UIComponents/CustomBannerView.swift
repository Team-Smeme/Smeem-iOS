//
//  CustomBannerView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2024/07/09.
//

import UIKit
import Combine

import SnapKit

final class CustomBannerView: BaseView {
    
    private (set) var closeButtonTapped = PassthroughSubject<Void, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .s1
        label.textColor = .smeemBlack
//        label.text = "헤더레이블"
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .c3
        label.textColor = .smeemBlack
//        label.text = "바디레이블"
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnCancelGrey, for: .normal)
        button.tintColor = .gray200
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
        subscribeButtonEvent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUI() {
        backgroundColor = .gray100
        layer.cornerRadius = 10
    }
}

extension CustomBannerView {
    private func setLayout() {
        addSubviews(titleLabel, bodyLabel, closeButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(22)
            make.leading.equalToSuperview().offset(18)
        }
        
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
        }
        
        closeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.size.equalTo(40)
        }
    }
    
    private func subscribeButtonEvent() {
        closeButton.tapPublisher.sink { [weak self] in
            self?.closeButtonTapped.send()
        }
        .store(in: &cancelBag)
    }
    
    func setLabelText(with title: String, body: String) {
        DispatchQueue.main.async {[weak self] in
            self?.titleLabel.text = title
            self?.bodyLabel.text = body
        }
    }
}
