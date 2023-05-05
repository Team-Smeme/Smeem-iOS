//
//  HomeViewController.swift
//  Smeem-iOS
//
//  Created by 임주민 on 2023/05/05.
//

import UIKit

import FSCalendar
import SnapKit

class HomeViewController: UIViewController {

    // MARK: - Property
    
    private let weekdayLabels = ["S", "M", "T", "W", "T", "F", "S"]
    
    // MARK: - UI Property
    
    private var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.placeholderType = .none
        calendar.appearance.todayColor = .point
        calendar.appearance.weekdayTextColor = .smeemBlack
        calendar.appearance.weekdayFont = .c3
        calendar.appearance.titleDefaultColor = .smeemBlack
        calendar.appearance.titleFont = .s3
        calendar.appearance.headerTitleColor = .smeemBlack
        calendar.appearance.headerTitleFont = .b4
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.appearance.borderRadius = 0.4
        return calendar
    }()
    private let indicator: UIView = {
        let indicator = UIView()
        indicator.layer.cornerRadius = 5
        indicator.backgroundColor = .gray300
        return indicator
    }()
    private let border: UIView = {
        let border = UIView()
        border.backgroundColor = .gray100
        return border
    }()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setBackgroundColor()
        setDelegate()
        setCalendar()
        setLayout()
    }
    
    // MARK: - @objc
    
    // MARK: - Custom Method
    
    private func setBackgroundColor() {
        view.backgroundColor = .white
    }
    private func setDelegate() {
        calendar.dataSource = self
        calendar.delegate = self
    }
    private func setCalendar() {
        calendar.headerHeight = convertByHeightRatio(66)
        calendar.weekdayHeight = convertByHeightRatio(41)
        for i in 0...6 {
            calendar.calendarWeekdayView.weekdayLabels[i].text = weekdayLabels[i]
        }
    }
    private func setLayout() {
        view.addSubviews(calendar, indicator, border)
        
        calendar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(convertByWidthRatio(19))
            $0.trailing.equalToSuperview().offset(-convertByWidthRatio(19))
            $0.height.equalTo(convertByWidthRatio(422))
        }
        indicator.snp.makeConstraints {
            $0.top.equalTo(calendar.snp.bottom).offset(convertByWidthRatio(12))
            $0.centerX.equalToSuperview()
            $0.height.equalTo(convertByWidthRatio(4))
            $0.width.equalTo(convertByWidthRatio(72))
        }
        border.snp.makeConstraints {
            $0.top.equalTo(indicator.snp.bottom).offset(convertByWidthRatio(12))
            $0.height.equalTo(6)
            $0.width.equalToSuperview()
        }
    }
}

// MARK: - Extension : FSCalendarDelegate

extension HomeViewController: FSCalendarDelegate {
}

// MARK: - Extension : FSCalendarDataSource

extension HomeViewController: FSCalendarDataSource {
}
