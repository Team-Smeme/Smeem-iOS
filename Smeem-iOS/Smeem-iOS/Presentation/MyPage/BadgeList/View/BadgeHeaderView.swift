//
//  BadgeHeaderView.swift
//  Smeem-iOS
//
//  Created by JH on 2023/06/28.
//

import UIKit

import SnapKit

enum HeaderLabelType {
    case welcome
    case diaryCount
    case dailyDiary
    case otherBadge
}

final class BadgeHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "BadgeHeaderView"
    
    // MARK: - Property
    
    var labelType: HeaderLabelType = .welcome {
        didSet {
            setLabelText()
        }
    }
    // MARK: - UI Property
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .s1
        label.textColor = .black
        return label
    }()
    
    // MARK: - Life Cycle
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - @objc
    // MARK: - Custom Method
    
    func setLabelText() {
        switch labelType {
        case .welcome:
            headerLabel.text = "웰컴 배지"
        case .diaryCount:
            headerLabel.text = "일기 누적 수"
        case .dailyDiary:
            headerLabel.text = "일기 연속 수"
        case .otherBadge:
            headerLabel.text = "부가 기능 활용"
        }
    }
    
    // MARK: - Layout
    
    func setLayout() {
        addSubview(headerLabel)
        
        headerLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
        }
    }
}
