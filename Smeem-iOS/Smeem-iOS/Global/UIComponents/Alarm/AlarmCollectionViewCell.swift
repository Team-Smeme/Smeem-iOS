//
//  AlarmCollectionViewCell.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/10.
//

import UIKit

final class AlarmCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "AlarmCollectionViewCell"
    
    var dayCellColor = true
    
    // MARK: - Property
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                if dayCellColor {
                    layer.borderWidth = 1.5
                    layer.borderColor = UIColor.point.cgColor
                    backgroundColor = .point
                    dayLabel.textColor = .white
                } else {
                    backgroundColor = .gray400
                    dayLabel.textColor = .white
                    layer.borderWidth = 0.0
                    layer.borderColor = nil
                }
            } else {
                backgroundColor = .white
                dayLabel.textColor = .gray400
                layer.borderWidth = 0.0
                layer.borderColor = nil
            }
        }
    }
    
    // MARK: - UI Property
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = .b2
        label.textColor = .gray400
        return label
    }()
    
    private let bottomLine: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor.gray100.cgColor
        return view
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setBackgroundColor()
        setLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Method
    
    func setData(_ text: String) {
        dayLabel.text = text
    }
    
    // MARK: - Layout
    
    private func setBackgroundColor() {
        backgroundColor = .white
    }
    
    private func setLayout() {
        addSubviews(dayLabel, bottomLine)
        
        dayLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        bottomLine.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1.5)
        }
    }

}
