//
//  SendFeedbackView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2024/07/23.
//

import UIKit
import Combine

import SnapKit

final class SendFeedbackView: UIView {
    
    private (set) var directButtonTapped = PassthroughSubject<Void, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .s1
        label.textColor = .smeemBlack
        label.text = "의견 보내기"
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor.gray100.cgColor
        view.makeRoundCorner(cornerRadius: 6)
        return view
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = .b4
        label.textColor = .smeemBlack
        label.text = "스밈에 대한 의견을 남겨주세요 :)"
        return label
    }()
    
    private let directButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .c3
        button.setTitleColor(.point, for: .normal)
        button.setTitle("바로가기", for: .normal)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        
        setLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        directButton.tapPublisher
            .sink { [weak self] _ in
                self?.directButtonTapped.send(())
            }
            .store(in: &cancelBag)
    }
    
    private func setLayout() {
        addSubviews(titleLabel, containerView)
        containerView.addSubviews(detailLabel, directButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(convertByHeightRatio(54))
        }
        
        detailLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(convertByWidthRatio(20))
        }
        
        directButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.equalTo(89)
            $0.height.equalTo(54)
        }
    }
}

