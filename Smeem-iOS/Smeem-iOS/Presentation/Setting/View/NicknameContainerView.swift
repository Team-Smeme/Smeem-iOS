//
//  NicknameContainerView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 5/7/24.
//

import UIKit
import Combine

final class NicknameContainerView: UIView {
    
    let editButtonTapped = PassthroughSubject<Void, Never>()
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
                self?.editButtonTapped.send(())
            }
            .store(in: &cancelBag)
    }
    
    
    func setNicknameData(data: String) {
        detailLabel.text = data
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
        
        editDetailButton.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.width.equalTo(89)
        }
    }
    
    private func setLabel() {
        titleLabel.text = "닉네임 변경"
        editDetailButton.setTitle("수정하기", for: .normal)
    }
}
