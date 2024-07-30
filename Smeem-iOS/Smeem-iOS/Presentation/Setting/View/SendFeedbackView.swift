//
//  SendFeedbackView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2024/07/23.
//

import UIKit
import Combine

final class SendFeedbackView: UIView {
    
    private (set) var goToButtonTapped = PassthroughSubject<Void, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .s1
        label.textColor = .smeemBlack
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
        return label
    }()
    
    private let editDetailButton: UIButton = {
        let label = UIButton()
        label.titleLabel?.font = .c3
        label.setTitleColor(.point, for: .normal)
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        setLayout()
        setLabel()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        editDetailButton.tapPublisher
            .sink { [weak self] _ in
                self?.goToButtonTapped.send(())
            }
            .store(in: &cancelBag)
    }
    
    private func setLayout() {
        addSubviews(titleLabel, containerView)
        containerView.addSubviews(detailLabel, editDetailButton)
        
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
    }
    
    private func setLabel() {
        titleLabel.text = "의견 보내기"
    }
    
    func hasPlanData(data: String) {
        detailLabel.text = data
        detailLabel.textColor = .black
        editDetailButton.setTitle("바로가기", for: .normal)
        
        editDetailButton.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.width.equalTo(89)
        }
    }
    
//    func hasNotPlanData() {
//        detailLabel.text = "아직 플랜이 없어요!"
//        detailLabel.textColor = .gray500
//        editDetailButton.setTitle("플랜 설정하기", for: .normal)
//        
//        editDetailButton.snp.makeConstraints {
//            $0.top.trailing.bottom.equalToSuperview()
//            $0.width.equalTo(117)
//        }
//    }
}

