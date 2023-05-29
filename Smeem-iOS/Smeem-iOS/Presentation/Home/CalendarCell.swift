//
//  CalendarCell.swift
//  Smeem-iOS
//
//  Created by 임주민 on 2023/05/29.
//

import Foundation
import UIKit

import FSCalendar

enum FilledType: Int {
    case none
    case some
    case today
}

enum SelectedType: Int {
    case not
    case single
}

final class CalendarCell: FSCalendarCell {
    weak var rectangleImageView: UIImageView!
    
    var filledType: FilledType = .none {
        didSet {
            setNeedsLayout()
        }
    }
    
    var selectedType: SelectedType = .not {
        didSet {
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let rectangleImageView = UIImageView(image: UIImage(named: "monthday"))
        self.contentView.insertSubview(rectangleImageView, at: 0)
        self.rectangleImageView = rectangleImageView
        self.shapeLayer.isHidden = true
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = 38.0
        let frame = CGRect(x: self.contentView.bounds.minX + 6.0,
                           y: self.contentView.bounds.minY + 2.0,
                           width: width,
                           height: width)
        self.rectangleImageView.frame = frame
        
        switch selectedType {
        case .not:
            self.rectangleImageView.image = nil
        case .single:
            self.rectangleImageView.image = UIImage(named: "monthday")
        }
        
        switch filledType {
        case .none:
            self.titleLabel.textColor = .smeemBlack
        case .some:
            self.titleLabel.textColor = .smeemBlack
            self.rectangleImageView.image = UIImage(named: "monthday")
        case .today:
            self.titleLabel.textColor = .smeemWhite
            self.rectangleImageView.image = UIImage(named: "monthToday")
        }
    }
    
    func configureUI(isSelected: Bool, with type: FilledType) {
        selectedType = isSelected ? .single : .not
        filledType = type
    }
}
