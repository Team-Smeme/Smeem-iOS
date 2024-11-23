//
//  DiaryBottomView.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/09/29.
//

import UIKit
import Combine

import SnapKit

enum DiaryBottomViewType {
    case standard
    case withHint
}

// MARK: - DiaryBottomView

final class DiaryBottomView: UIView {
    
    // MARK:  - Properties
    
    private let viewType: DiaryBottomViewType
    
    private (set) var randomTopicButtonTapped = PassthroughSubject<Void, Never>()
    private (set) var hintButtonTapped = PassthroughSubject<Bool, Never>()
    
    private var cancelBag = Set<AnyCancellable>()
    
    // MARK: - UI Properties
    
    private let thinLine = SeparationLine(height: .thin)
    
    private lazy var randomTopicButton = UIButton()
    
    private lazy var hintButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.btnTranslateInactive, for: .normal)
        return button
    }()
    
    // MARK: - Life Cycle
    
    init(frame: CGRect = .zero, viewType: DiaryBottomViewType) {
        self.viewType = viewType
        super.init(frame: frame)
        
        setupUI()
        setupLayout()
        setRandomTopicDisabled()
        subscirbeButtonEvents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension DiaryBottomView {
    
    // MARK: - Layout Helpers
    
    private func setupUI() {
        setBackgroundColor()
        setRandomTopicImage()
    }
    
    // 재사용 가능할지도..?
    private func setBackgroundColor() {
        self.backgroundColor = .gray100
    }
    
    private func setRandomTopicImage() {
        switch viewType {
        case .standard:
            randomTopicButton.setImage(Constant.Image.btnRandomSubjectInactive, for: .normal)
        case .withHint:
            randomTopicButton.setImage(Constant.Image.btnRandomSubjectEnabled, for: .normal)
        }
    }
    
    private func setRandomTopicDisabled() {
        if viewType == .withHint {
            randomTopicButton.isEnabled = false
        }
    }
    
    private func setupLayout() {
        addSubviews(thinLine, randomTopicButton)
        
        thinLine.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.top)
            make.centerX.equalToSuperview()
        }
        
        randomTopicButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(convertByHeightRatio(17 - 5))
            make.trailing.equalToSuperview().offset(convertByWidthRatio(-18 + 5))
            make.width.equalTo(convertByWidthRatio(78 + 10))
            make.height.equalTo(convertByHeightRatio(19 + 10))
        }
        
        if viewType == .withHint {
            addSubview(hintButton)
            hintButton.snp.makeConstraints { make in
                make.centerY.equalTo(randomTopicButton)
                make.leading.equalToSuperview().offset(18 - 10)
                make.width.equalTo(convertByWidthRatio(92 + 10))
                make.height.equalTo(convertByHeightRatio(29 + 10))
            }
        }
    }
    
    // MARK: - Action Helpers
    
    private func subscirbeButtonEvents() {
        randomTopicButton.tapPublisher.sink { [weak self] in
            self?.randomTopicButtonTapped.send()
        }
        .store(in: &cancelBag)
        
        hintButton.tapPublisher.sink { [weak self] in
            self?.hintButtonTapped.send(true)
        }
        .store(in: &cancelBag)
    }
    
    func updateRandomTopicButtonImage(_ isEnabled: Bool) {
        randomTopicButton.setImage(isEnabled ? Constant.Image.btnRandomSubjectActive : Constant.Image.btnRandomSubjectInactive, for: .normal)
    }
    
    func updateHintButtonImage(_ isHintShowed: Bool) {
        hintButton.setImage(isHintShowed ? Constant.Image.btnTranslateActive : Constant.Image.btnTranslateInactive, for: .normal)
    }
}
