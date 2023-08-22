//
//  CalendarCell.swift
//  Smeem-iOS
//
//  Created by 임주민 on 2023/05/29.
//

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
        
        setBackgroundDefaultCell()
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = 38.0
        let frame = CGRect(x: self.contentView.bounds.minX
                              + (self.contentView.bounds.width - 38) / 2,
                           y: self.contentView.bounds.minY
                              + (self.contentView.bounds.height - 38) / 4,
                           width: width,
                           height: width)
        rectangleImageView.frame = frame
        
        switch selectedType {
        case .not:
            rectangleImageView.image = nil
        case .single:
            titleLabel.textColor = .smeemBlack
            rectangleImageView.image = Constant.Image.monthday
        }
        
        switch filledType {
        case .none:
            titleLabel.textColor = (self.selectedType == .single)
            ? .smeemBlack
            : .gray400
        case .some:
            titleLabel.textColor = .smeemBlack
        case .today:
            titleLabel.textColor = .smeemWhite
            rectangleImageView.image = Constant.Image.monthToday
        }
    }
    
    func setBackgroundDefaultCell() {
        let rectangleImageView = UIImageView(image: Constant.Image.monthday)
        contentView.insertSubview(rectangleImageView, at: 0)
        self.rectangleImageView = rectangleImageView
        shapeLayer.isHidden = true
    }
    
    func configureUI(isSelected: Bool, with type: FilledType) {
        selectedType = isSelected ? .single : .not
        filledType = type
    }
}
