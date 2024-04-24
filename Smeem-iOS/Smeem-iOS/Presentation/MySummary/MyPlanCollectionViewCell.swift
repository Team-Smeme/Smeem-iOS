//
//  MyPlanCollectionViewCell.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 4/23/24.
//

import UIKit

final class MyPlanCollectionViewCell: UICollectionViewCell {
    
    private let borderLayer = CAShapeLayer()
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = .c5
        label.textColor = .gray600
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func activateCell() {
        self.layer.cornerRadius = self.layer.frame.size.width / 2
        self.backgroundColor = .point
        self.numberLabel.textColor = .smeemWhite
    }
    
    func deactivateCell() {
        self.numberLabel.textColor = .gray600
        borderLayer.strokeColor = UIColor.gray600.cgColor
        borderLayer.lineDashPattern = [2, 2]
        borderLayer.fillColor = UIColor.clear.cgColor
        
        borderLayer.path = UIBezierPath(roundedRect: self.bounds,
                                        cornerRadius: self.layer.bounds.size.width / 2).cgPath
         
        layer.addSublayer(borderLayer)
    }
    
    func setNumberData(text: String) {
        numberLabel.text = text
    }
    
    private func setLayout() {
        addSubview(numberLabel)
        
        numberLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
