//
//  HomeViewController.swift
//  Smeem-iOS
//
//  Created by 임주민 on 2023/05/05.
//

import UIKit
import Combine

import FSCalendar
import SnapKit

final class HomeViewController: BaseViewController {
    
    // MARK: - Property
    
    private var foreignDiaryViewModel = ForeignDiaryViewModel(model: DiaryModel())
    
    private let weekdayLabels = ["S", "M", "T", "W", "T", "F", "S"]
    private let gregorian = Calendar(identifier: .gregorian)
    private var homeDiaryDict = [String: HomeDiaryCustom]()
    private var writtenDaysStringList = [String]()
    private var currentDate = Date()
    private var emptyViewWithTopConstraint: Constraint?
    var badgePopupData = [PopupBadge]()
    var isKeyboardVisible: Bool = false
    var keyboardHeight: CGFloat = 0.0
    private var toastMessageFlag = false {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.loadToastMessage()
            }
        }
    }
    
    private var cancelBag = Set<AnyCancellable>()
    
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
        calendar.headerHeight = convertByHeightRatio(77)
        calendar.weekdayHeight = convertByHeightRatio(17)
        for i in 0...6 {
            calendar.calendarWeekdayView.weekdayLabels[i].text = weekdayLabels[i]
        }
        return calendar
    }()
    
    private let indicator: UIView = {
        let indicator = UIView()
        indicator.layer.cornerRadius = 2
        indicator.backgroundColor = .gray300
        return indicator
    }()
    
    private let border: UIView = {
        let border = UIView()
        border.backgroundColor = .gray100
        return border
    }()
    
    private lazy var diaryThumbnail: UIView = {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(fullViewButtonDidTap(_:)))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let diaryDate: UILabel = {
        let diaryDate = UILabel()
        diaryDate.textColor = .smeemBlack
        diaryDate.font = .s3
        return diaryDate
    }()
 
    private let diaryText: UILabel = {
        let diaryText = UILabel()
        diaryText.textColor = .smeemBlack
        diaryText.font = .b4
        diaryText.numberOfLines = 3
        diaryText.lineBreakMode = .byTruncatingTail
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
        symbol.image = Constant.Image.icnRightArrow
        return symbol
    }()
    
    private let emptyView = UIView()
    
    private let emptyPaddingView = UIView()
    
    private let emptySymbol = UIImageView(image: Constant.Image.noDiary)
    
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
        floatingView.isHidden = true
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
        xButton.setImage(Constant.Image.icnCancelGrey, for: .normal)
        xButton.addTarget(self, action: #selector(self.xButtonDidTap(_:)), for: .touchUpInside)
        return xButton
    }()
    
    private let myPageButton: UIButton = {
        let myPageButton = UIButton()
        myPageButton.setImage(Constant.Image.icnMyPage, for: .normal)
        return myPageButton
    }()
    
    private lazy var myPageBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(myPageButtonDidTap(_:)))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var addDiaryButton: SmeemButton = {
        let addDiaryButton = SmeemButton(buttonType: .enabled, text: "일기 작성하기")
        addDiaryButton.addTarget(self, action: #selector(self.addDiaryButtonDidTap(_:)), for: .touchUpInside)
        return addDiaryButton
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBottomLayout(date: currentDate)
        setBackgroundColor()
        setLayout()
        setDelegate()
        setSwipe()
        subscribe()
        
        AmplitudeManager.shared.track(event: AmplitudeConstant.home.home_view.event)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        homeDiaryWithAPI(start: Date().startOfMonth().addingDate(addValue: -7), end: Date().endOfMonth().addingDate(addValue: 7))
        checkPopupView()
    }
    
    // MARK: - @objc
    
    @objc func swipeEvent(_ swipe: UISwipeGestureRecognizer) {
        if (swipe.location(in: self.view).y < border.frame.origin.y + 20) {
            if swipe.direction == .down {
                AmplitudeManager.shared.track(event: AmplitudeConstant.home.full_calendar_appear.event)
            }
            
            let topConstant: CGFloat = (swipe.direction == .up) ? 168 : 60
            let newScopeMode: FSCalendarScope = (swipe.direction == .up) ? .week : .month
            calendar.setScope(newScopeMode, animated: true)
            emptyViewWithTopConstraint?.update(offset: topConstant)
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func fullViewButtonDidTap(_ gesture: UITapGestureRecognizer) {
        let detailDiaryVC = DetailDiaryViewController()
        detailDiaryVC.diaryId = homeDiaryDict[currentDate.toString("yyyy-MM-dd")]?.diaryId ?? 0
        self.navigationController?.pushViewController(detailDiaryVC, animated: true)
    }
    
    @objc func floatingViewDidTap(_ gesture: UITapGestureRecognizer) {
        // 뷰 이동 - 30일 전 상세일기
    }
    
    @objc func myPageButtonDidTap(_ sender: UIButton) {
        let myPageVC = MySummaryViewController()
        self.navigationController?.pushViewController(myPageVC, animated: true)
    }
    
    @objc func xButtonDidTap(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.floatingView.alpha = 0.0
        }, completion: {_ in
            self.floatingView.isHidden = true
        })
    }
    
    @objc func addDiaryButtonDidTap(_ sender: UIButton) {
        let newVC = HomeViewFloatingViewController()
        newVC.modalTransitionStyle = .crossDissolve
        newVC.modalPresentationStyle = .overFullScreen
        self.present(newVC, animated: true, completion: nil)
    }
    
    @objc func notificationPushShowPage() {
        
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
        diaryText.text = homeDiaryDict[currentDate.toString("yyyy-MM-dd")]?.content
        diaryDate.text = homeDiaryDict[currentDate.toString("yyyy-MM-dd")]?.createdTime.formatted("h : mm a")
        diaryText.setTextWithLineHeight(lineHeight: 22)
        diaryText.lineBreakMode = .byTruncatingTail
    }
    
    private func checkPopupView() {
        if !badgePopupData.isEmpty {
            let popupVC = BadgePopupViewController(popupBadge: badgePopupData)
            popupVC.modalTransitionStyle = .crossDissolve
            popupVC.modalPresentationStyle = .overCurrentContext
            self.present(popupVC, animated: true)
        }
        badgePopupData = []
    }
    
    private func loadToastMessage() {
        showToast(toastType: .smeemToast(bodyType: .completed))
    }
    
    private func pushShowPage() {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationPushShowPage), name: NSNotification.Name("goToHome"), object: nil)
    }
    
    private func getSomeData(completion: @escaping () -> ()) {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        completion()
      }
    }
    
    private func subscribe() {
        foreignDiaryViewModel.diaryPostedSubject
            .compactMap { $0 }
            .sink { [weak self] response in
                self?.handlePostDiaryAPI(with: response)
            }
            .store(in: &cancelBag)
    }
    
    func handlePostDiaryAPI(with response: PostDiaryResponse?) {
        toastMessageFlag = true
        badgePopupData = response?.badges ?? []
    }
    
    // MARK: - Layout
    
    private func setLayout() {
        hiddenNavigationBar()
        
        view.addSubviews(calendar, myPageButton, indicator, border, diaryThumbnail, emptyView, floatingView, addDiaryButton, myPageBackView)
        diaryThumbnail.addSubviews(diaryDate, fullViewButtonText, fullViewButtonSymbol, diaryText)
        emptyView.addSubviews(emptyPaddingView, emptySymbol, emptyText)
        floatingView.addSubviews(waitingLabel, adviceLabel, xButton)
        
        calendar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(constraintByNotch(convertByWidthRatio(-20), convertByWidthRatio(-10)))
            $0.leading.equalToSuperview().offset(convertByWidthRatio(15))
            $0.trailing.equalToSuperview().offset(-convertByWidthRatio(15))
            $0.height.equalTo(convertByWidthRatio(422))
        }
        
        myPageButton.snp.makeConstraints {
            $0.top.equalTo(calendar.calendarHeaderView.snp.top).inset(constraintByNotch(convertByWidthRatio(25), convertByWidthRatio(18)))
            $0.trailing.equalToSuperview().inset(18)
            $0.width.height.equalTo(convertByHeightRatio(40))
        }
        
        myPageBackView.snp.makeConstraints {
            $0.center.equalTo(myPageButton.snp.center)
            $0.height.width.equalTo(convertByHeightRatio(55))
        }
        
        indicator.snp.makeConstraints {
            $0.top.equalTo(calendar.snp.bottom).offset(convertByWidthRatio(4))
            $0.centerX.equalToSuperview()
            $0.height.equalTo(convertByWidthRatio(4))
            $0.width.equalTo(convertByWidthRatio(72))
        }
        
        border.snp.makeConstraints {
            $0.top.equalTo(indicator.snp.bottom).offset(convertByWidthRatio(12))
            $0.centerX.equalToSuperview()
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
        
        fullViewButtonSymbol.snp.makeConstraints {
            $0.top.equalToSuperview().offset(convertByHeightRatio(20))
            $0.trailing.equalToSuperview().offset(-convertByWidthRatio(22))
            $0.height.equalTo(convertByHeightRatio(10))
            $0.width.equalTo(convertByWidthRatio(6))
        }
        
        fullViewButtonText.snp.makeConstraints {
            $0.centerY.equalTo(fullViewButtonSymbol.snp.centerY)
            $0.trailing.equalTo(fullViewButtonSymbol.snp.leading).offset(-convertByWidthRatio(8))
        }
        
        emptyView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(diaryThumbnail)
            $0.bottom.equalToSuperview()
        }
        
        emptyPaddingView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(diaryThumbnail)
            self.emptyViewWithTopConstraint = $0.height.equalTo(168).constraint
        }
        
        emptySymbol.snp.makeConstraints {
            $0.top.equalTo(emptyPaddingView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(convertByHeightRatio(47))
            $0.width.equalTo(convertByWidthRatio(65))
        }
        
        emptyText.snp.makeConstraints {
            $0.top.equalTo(emptySymbol.snp.bottom).offset(convertByHeightRatio(16))
            $0.centerX.equalToSuperview()
        }
        
        floatingView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-convertByHeightRatio(120))
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
            $0.trailing.equalToSuperview().inset(convertByWidthRatio(8))
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(convertByWidthRatio(40))
        }
        
        addDiaryButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(convertByHeightRatio(50))
            $0.centerX.equalToSuperview()
            $0.width.equalTo(convertByWidthRatio(339))
            $0.height.equalTo(convertByHeightRatio(60))
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
    /// 페이지 바뀔 때 호출되는 함수
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        homeDiaryWithAPI(start: calendar.currentPage.startOfMonth().addingDate(addValue: -7), end: calendar.currentPage.endOfMonth().addingDate(addValue: 7))
        calendar.reloadData()
        configureBottomLayout(date: currentDate)
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        guard let cell = calendar.dequeueReusableCell(
            withIdentifier: "cell",
            for: date,
            at: position
        ) as? CalendarCell else { return FSCalendarCell() }
        configure(cell: cell, for: date, at: position)
        return cell
    }
    
    /// 달력에 보여지는 모든 셀들의 배경 디자인 설정
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        guard let cell = cell as? CalendarCell else { return }
        
        let filledType = checkFilledType(of: date)
        let isSelected = calendar.selectedDates.contains(date)
        
        cell.configureUI(isSelected: isSelected, with: filledType)
    }
    
    /// 해당 셀의 FilledType 체크 (오늘 / 일기 있는 날 / 일기 없는 날)
    private func checkFilledType(of date: Date) -> FilledType {
        if gregorian.isDateInToday(date) { /// 오늘인 경우
            return .today
        } else { /// 오늘 아닌경우 -> 일기 있는 날과 없는 날로 구분
            return writtenDaysStringList.contains(date.toString("yyyy-MM-dd")) ? .some : .none
        }
    }
}

extension HomeViewController: FSCalendarDelegateAppearance {
    /// 날짜 선택 시 콜백 메소드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        currentDate = date
        setData()
        configureSelectedUI()
        configureBottomLayout(date: date)
    }

    /// 달력의 선택된 셀 배경 디자인 변경
    private func configureSelectedUI() {
        calendar.visibleCells().forEach { (cell) in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
    
    /// 홈뷰 하단 레이아웃 설정
    private func configureBottomLayout(date: Date) {
        let isHavingTodayDiary = writtenDaysStringList.contains(date.toString("yyyy-MM-dd"))
        diaryThumbnail.isHidden = !isHavingTodayDiary
        emptyView.isHidden = isHavingTodayDiary
        addDiaryButton.isHidden = (gregorian.isDateInToday(date) && !isHavingTodayDiary) ? false : true
        if (!floatingView.isHidden) {
            floatingView.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(-convertByHeightRatio(addDiaryButton.isHidden ? 50 : 120))
            }
        }
    }
}

// MARK: - Extension : Network

extension HomeViewController {
    /// 이번 달+a (앞뒤로 일주일 여유분까지) 일기 불러오는 함수
    func homeDiaryWithAPI(start: String, end: String) {
        SmeemLoadingView.showLoading()
        
        HomeAPI.shared.homeDiaryList(startDate: start, endDate: end) { result in
            
            switch result {
            case .success(let response):
                
                response.diaries.forEach {
                    self.homeDiaryDict[String($0.createdAt.prefix(10))] = HomeDiaryCustom(diaryId: $0.diaryId, content: $0.content, createdTime: String($0.createdAt.suffix(5)))
                }
                self.writtenDaysStringList = self.homeDiaryDict
                    .map { $0.key }
                self.setData()
                self.configureBottomLayout(date: self.currentDate)
                self.calendar.reloadData()
            case .failure(let error):
                self.showToast(toastType: .smeemErrorToast(message: error))
            }
            
            SmeemLoadingView.hideLoading()
        }
    }
}
