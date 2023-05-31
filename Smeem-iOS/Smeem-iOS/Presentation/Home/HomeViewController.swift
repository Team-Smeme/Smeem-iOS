//
//  HomeViewController.swift
//  Smeem-iOS
//
//  Created by 임주민 on 2023/05/05.
//

import UIKit

import FSCalendar
import SnapKit

final class HomeViewController: UIViewController {
    
    // MARK: - Property
    
    private let weekdayLabels = ["S", "M", "T", "W", "T", "F", "S"]
    private let gregorian = Calendar(identifier: .gregorian)
    private var writtenDays = [Date]()
    private var writtenDaysfromServer = ["2023-05-01","2023-05-03","2023-05-10","2023-05-15","2023-05-20","2023-05-23","2023-05-30","2023-05-31"]
    private let tmpText = ["I watched Avatar with my boyfriend at Hongdae CGV. I should have skimmed the previous season - Avatar1.. I really couldn’t get what they were saying and the universe(??). What I was annoyed then was 두팔 didn’t know that as me. I think 두팔 who is my boyfriend should study before wathcing…. but Avatar2 is amazing movie I think. In my personal opinion, the jjin main character of Avatar2 is not Sully, but his son.", "4 : 18 PM"]
    private var isWating30days = true
    
    // MARK: - UI Property
    
    private lazy var calendar: FSCalendar = {
        let calendar = FSCalendar()
        calendar.placeholderType = .none
        calendar.scope = .week
        calendar.appearance.weekdayTextColor = .smeemBlack
        calendar.appearance.weekdayFont = .c3
        calendar.appearance.titleDefaultColor = .smeemBlack
        calendar.appearance.titleFont = .s3
        calendar.appearance.headerTitleColor = .smeemBlack
        calendar.appearance.headerTitleFont = .b4
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.appearance.borderRadius = 0.4
        calendar.register(CalendarCell.self, forCellReuseIdentifier: "cell")
        calendar.headerHeight = convertByHeightRatio(66)
        calendar.weekdayHeight = convertByHeightRatio(41)
        for i in 0...6 {
            calendar.calendarWeekdayView.weekdayLabels[i].text = weekdayLabels[i]
        }
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
    
    private let diaryThumbnail = UIView()
    
    private let diaryDate: UILabel = {
        let diaryDate = UILabel()
        diaryDate.textColor = .smeemBlack
        diaryDate.font = .s3
        return diaryDate
    }()
    
    private lazy var fullViewButton: UIView = {
        let fullViewButton = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(fullViewButtonDidTap(_:)))
        fullViewButton.addGestureRecognizer(tapGesture)
        fullViewButton.isUserInteractionEnabled = true
        return fullViewButton
    }()
 
    private let diaryText: UILabel = {
        let diaryText = UILabel()
        diaryText.textColor = .smeemBlack
        diaryText.font = .b4
        diaryText.numberOfLines = 3
        diaryText.lineBreakMode = .byWordWrapping
        return diaryText
    }()
    
    private let fullViewButtonText: UILabel = {
        let text = UILabel()
        text.text = "전체보기"
        text.textColor = .gray400
        text.font = .c2
        return text
    }()
    
    private let fullViewButtonSymbol: UIImageView = {
        let symbol = UIImageView()
        symbol.image = UIImage(named: "rightArrow")
        return symbol
    }()
    
    private let emptyView = UIView()
    private let emptySymbol = UIImageView(image: UIImage(named: "noDiary"))
    
    private let emptyText: UILabel = {
        let emptyText = UILabel()
        emptyText.text = "작성된 일기가 없어요."
        emptyText.font = .c3
        emptyText.textColor = .gray300
        return emptyText
    }()
    
    private lazy var floatingView: UIView = {
        let floatingView = UIView()
        floatingView.backgroundColor = .gray100
        floatingView.layer.cornerRadius = 10
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(floatingViewDidTap(_:)))
        floatingView.addGestureRecognizer(tapGesture)
        return floatingView
    }()
    
    private let waitingLabel: UILabel = {
        let waitingLabel = UILabel()
        waitingLabel.text = "30일 전의 일기가 기다리고 있어요!"
        waitingLabel.font = .s1
        waitingLabel.textColor = .smeemBlack
        return waitingLabel
    }()
    
    private let adviceLabel: UILabel = {
        let adviceLabel = UILabel()
        adviceLabel.text = "이전 일기를 첨삭하고 더 어쩌구 해보세요"
        adviceLabel.font = .c3
        adviceLabel.textColor = .smeemBlack
        return adviceLabel
    }()
    
    private lazy var xButton: UIButton = {
        let xButton = UIButton()
        xButton.setImage(UIImage(named: "icnCancelGrey"), for: .normal)
        xButton.addTarget(self, action: #selector(self.xButtonDidTap(_:)), for: .touchUpInside)
        return xButton
    }()
    
    private lazy var myPageButton: UIButton = {
        let myPageButton = UIButton()
        myPageButton.setImage(UIImage(named: "icn_mypage"), for: .normal)
        myPageButton.addTarget(self, action: #selector(self.myPageButtonDidTap(_:)), for: .touchUpInside)
        return myPageButton
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        setLayout()
        setDelegate()
        setSwipe()
        setData()
        setEvents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        floatingView.isHidden = !isWating30days
    }
    
    // MARK: - @objc
    
    @objc func swipeEvent(_ swipe: UISwipeGestureRecognizer) {
        if (swipe.location(in: self.view).y < border.frame.origin.y+20) {
            calendar.setScope((swipe.direction == .up) ? .week : .month, animated: true)
        }
    }

    @objc func fullViewButtonDidTap(_ gesture: UITapGestureRecognizer) {
        // 뷰 이동 - 상세일기
    }
    
    @objc func floatingViewDidTap(_ gesture: UITapGestureRecognizer) {
        // 뷰 이동 - 30일 전 상세일기
    }
    
    @objc func myPageButtonDidTap(_ sender: UIButton) {
        // 뷰 이동 - 마이페이지
    }
    
    @objc func xButtonDidTap(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.floatingView.alpha = 0.0
        }, completion: {_ in
            self.floatingView.removeFromSuperview()
        })
    }
    
    // MARK: - Custom Method
    
    private func setDelegate() {
        calendar.dataSource = self
        calendar.delegate = self
    }
    
    private func setSwipe() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeEvent(_:)))
        swipeUp.direction = .up
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeUp)
        view.addGestureRecognizer(swipeDown)
    }
    
    private func setData() {
        diaryText.text = tmpText[0]
        diaryDate.text = tmpText[1]
        diaryText.setTextWithLineHeight(lineHeight: 22)
    }
    
    func setEvents() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        writtenDays = writtenDaysfromServer
            .map { dateFormatter.date(from: $0)! }
        
        diaryThumbnail.isHidden = !writtenDaysfromServer.contains(dateFormatter.string(from: Date()))
        emptyView.isHidden = !diaryThumbnail.isHidden
    }
    
    // MARK: - Layout
    
    private func setBackgroundColor() {
        view.backgroundColor = .white
    }
    
    private func setLayout() {
        hiddenNavigationBar()
        
        view.addSubviews(calendar, myPageButton, indicator, border, diaryThumbnail, emptyView, floatingView, xButton)
        diaryThumbnail.addSubviews(diaryDate, fullViewButton, diaryText)
        fullViewButton.addSubviews(fullViewButtonText, fullViewButtonSymbol)
        emptyView.addSubviews(emptySymbol, emptyText)
        floatingView.addSubviews(waitingLabel, adviceLabel)
        
        calendar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(convertByWidthRatio(15))
            $0.trailing.equalToSuperview().offset(-convertByWidthRatio(15))
            $0.height.equalTo(convertByWidthRatio(422))
        }
        
        myPageButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(convertByHeightRatio(66)/2-convertByHeightRatio(40)/2)
            $0.trailing.equalToSuperview().offset(-convertByWidthRatio(18))
            $0.width.height.equalTo(convertByHeightRatio(40))
        }
        
        indicator.snp.makeConstraints {
            $0.top.equalTo(calendar.snp.bottom).offset(convertByWidthRatio(12))
            $0.centerX.equalToSuperview()
            $0.height.equalTo(convertByWidthRatio(4))
            $0.width.equalTo(convertByWidthRatio(72))
        }
        
        border.snp.makeConstraints {
            $0.top.equalTo(indicator.snp.bottom).offset(convertByWidthRatio(12))
            $0.height.equalTo(convertByHeightRatio(6))
            $0.width.equalToSuperview()
        }
        
        diaryThumbnail.snp.makeConstraints {
            $0.top.equalTo(border.snp.bottom)
            $0.centerX.width.equalToSuperview()
            $0.height.equalTo(convertByHeightRatio(122))
        }
        
        diaryText.snp.makeConstraints {
            $0.top.equalToSuperview().offset(convertByHeightRatio(54))
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(convertByWidthRatio(18))
            $0.trailing.equalToSuperview().offset(-convertByWidthRatio(18))
        }
        
        diaryDate.snp.makeConstraints {
            $0.top.equalToSuperview().offset(convertByHeightRatio(20))
            $0.leading.equalTo(diaryText.snp.leading)
        }
        
        fullViewButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(convertByHeightRatio(20))
            $0.trailing.equalToSuperview().offset(-convertByWidthRatio(22))
            $0.width.equalTo(convertByWidthRatio(61))
            $0.height.equalTo(17)
        }
        
        fullViewButtonText.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        fullViewButtonSymbol.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(diaryThumbnail)
            $0.bottom.equalToSuperview()
        }
        
        emptySymbol.snp.makeConstraints {
            $0.top.equalToSuperview().offset(convertByHeightRatio(60))
            $0.centerX.equalToSuperview()
            $0.height.equalTo(convertByHeightRatio(47))
            $0.width.equalTo(convertByWidthRatio(65))
        }
        
        emptyText.snp.makeConstraints {
            $0.top.equalTo(emptySymbol.snp.bottom).offset(convertByHeightRatio(16))
            $0.centerX.equalToSuperview()
        }
        
        floatingView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(convertByHeightRatio(50))
            $0.centerX.equalToSuperview()
            $0.width.equalTo(convertByWidthRatio(339))
            $0.height.equalTo(convertByHeightRatio(88))
        }
        
        waitingLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(convertByHeightRatio(22))
            $0.leading.equalToSuperview().offset(convertByWidthRatio(18))
        }
        
        adviceLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-convertByHeightRatio(24))
            $0.leading.equalTo(waitingLabel.snp.leading)
        }
        
        xButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-convertByWidthRatio(26))
            $0.centerY.equalTo(floatingView.snp.centerY)
            $0.width.height.equalTo(convertByWidthRatio(40))
        }
    }
}

// MARK: - Extension : FSCalendarDelegate

extension HomeViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints {
            $0.height.equalTo(bounds.height)
        }
        view.layoutIfNeeded()
    }
}

// MARK: - Extension : FSCalendarDataSource

extension HomeViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(
            withIdentifier: "cell",
            for: date,
            at: position
        ) as? CalendarCell else { return FSCalendarCell() }
        configure(cell: cell, for: date, at: position)
        return cell
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        guard let cell = cell as? CalendarCell else { return }
        let filledType: FilledType = checkDate(for: date)
        checkSeletedDates(cell, for: date, typeFor: filledType)
    }
    
    private func checkDate(for date: Date) -> FilledType {
        if gregorian.isDateInToday(date) {
            return .today
        } else {
            return writtenDays.contains(date) ? .some : .none
        }
    }
    
    private func checkSeletedDates(_ cell: CalendarCell, for date: Date, typeFor filledType: FilledType) {
        let isSelected = calendar.selectedDates.contains(date)
        cell.configureUI(isSelected: isSelected, with: filledType)
    }
}

extension HomeViewController: FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        configureVisibleCells()
        // TODO: - 매번 contain 쓰지말고 더 효율적인 방안 모색해보기
        diaryThumbnail.isHidden = !writtenDays.contains(date)
        emptyView.isHidden = !diaryThumbnail.isHidden
    }

    private func configureVisibleCells() {
        calendar.visibleCells().forEach { (cell) in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
}
