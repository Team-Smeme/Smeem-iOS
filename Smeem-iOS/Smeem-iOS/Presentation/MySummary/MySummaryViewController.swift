//
//  MySummaryViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 4/22/24.
//

import UIKit
import SnapKit
import Combine

final class MySummaryViewController: BaseViewController {
    
    // MARK: Publisher
    
    private let mySummarySubject = PassthroughSubject<Void, Never>()
    private let myPlanSubject = PassthroughSubject<Void, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    private var mySmeemDatasource: MySmeemCollectionViewDataSource!
    private let myPlanDataArray = ["1", "2", "3", "4", "5", "6", "7"]
    private let viewModel = MySummaryViewModel(provider: MySummaryService())
    
    // MARK: UI Properties
    
    private let summaryScrollerView: UIScrollView = {
        let scrollerView = UIScrollView()
        scrollerView.showsVerticalScrollIndicator = false
        return scrollerView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let naviView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnBack, for: .normal)
        return button
    }()
    
    private let summaryLabel: UILabel = {
        let label = UILabel()
        label.text = "성과 요약"
        label.font = .s2
        label.textColor = .black
        return label
    }()
    
    private let settingButton: UIButton = {
        let button = UIButton()
        button.setTitle("설정", for: .normal)
        button.setTitleColor(.gray500, for: .normal)
        return button
    }()
    
    private let mySmeemLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 스밈"
        label.font = .s1
        label.textColor = .black
        return label
    }()
    
    private let mySmeemView: UIView = {
        let view = UIView()
        view.makeRoundCorner(cornerRadius: 15)
        view.backgroundColor = .clear
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray100.cgColor
        return view
    }()
    
    private lazy var mySmeemCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private let myPlanLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 플랜"
        label.font = .s1
        label.textColor = .black
        return label
    }()
    
    private let myPlanView: UIView = {
        let view = UIView()
        view.makeRoundCorner(cornerRadius: 15)
        view.backgroundColor = .clear
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray100.cgColor
        view.isHidden = true
        return view
    }()
    
    private let myPlanTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "매일 일기 작성하기"
        label.font = .s2
        label.textColor = .black
        return label
    }()
    
    private let myPlanDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "유창한 비지니스 영어"
        label.font = .c2
        label.textColor = .black
        return label
    }()
    
    private lazy var myPlanCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private let emptyView: UIView = {
        let view = UIView()
        view.makeRoundCorner(cornerRadius: 15)
        view.backgroundColor = .clear
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray100.cgColor
        view.isHidden = true
        return view
    }()
    
    private let emptyPlanLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 플랜이 없어요!"
        label.font = .b2
        label.textColor = .gray500
        return label
    }()
    
    private let planSettingLabel: UILabel = {
        let label = UILabel()
        label.text = "플랜 설정하러 가기"
        label.font = .c2
        label.textColor = .gray400
        return label
    }()
    
    private let emptyLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 6
        stackView.alignment = .center
        return stackView
    }()
    
    private let myBadgeLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 배지"
        label.font = .s1
        label.textColor = .black
        return label
    }()
    
    private lazy var myBadgeCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        mySummarySubject.send(())
        myPlanSubject.send(())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        registerCell()
        setDelegate()
        bind()
    }
    
    // MARK: - Method
    
    private func bind() {
        backButton.tapPublisher
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancelBag)
        
        let input = MySummaryViewModel.Input(mySummarySubject: mySummarySubject,
                                             myPlanSubject: myPlanSubject)
        let output = viewModel.transform(input: input)
        
        output.totalHasMyPlanResult
            .sink { [weak self] response in
                self?.emptyView.removeFromSuperview()
                self?.myPlanView.isHidden = false
                self?.mySmeemDatasource = MySmeemCollectionViewDataSource(numberItems: response.mySummaryNumber,
                                                                          textItems: response.mySumamryText)
                self?.mySmeemCollectionView.dataSource = self?.mySmeemDatasource
                self?.mySmeemCollectionView.reloadData()
            }
            .store(in: &cancelBag)
        
        output.totalHasNotPlanResult
            .sink { [weak self] response in
                self?.myPlanView.removeFromSuperview()
                self?.emptyView.isHidden = false
                self?.mySmeemDatasource = MySmeemCollectionViewDataSource(numberItems: response.mySummaryNumber,
                                                                          textItems: response.mySumamryText)
                self?.mySmeemCollectionView.dataSource = self?.mySmeemDatasource
                self?.mySmeemCollectionView.reloadData()
            }
            .store(in: &cancelBag)
        
        output.errorResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.showToast(toastType: .smeemErrorToast(message: error))
            }
            .store(in: &cancelBag)
        
        output.loadingViewResult
            .receive(on: DispatchQueue.main)
            .sink { isShown in
                isShown ? SmeemLoadingView.showLoading() : SmeemLoadingView.hideLoading()
            }
            .store(in: &cancelBag)
    }
    
    private func setLayout() {
        view.addSubview(summaryScrollerView)
        summaryScrollerView.addSubview(contentView)
        contentView.addSubviews(naviView, mySmeemLabel, mySmeemView,
                                myPlanLabel, myPlanView, emptyView,
                                myBadgeLabel, myBadgeCollectionView)
        naviView.addSubviews(backButton, summaryLabel, settingButton)
        mySmeemView.addSubview(mySmeemCollectionView)
        myPlanView.addSubviews(myPlanTitleLabel, myPlanDetailLabel, myPlanCollectionView)
        emptyView.addSubviews(emptyLabelStackView)
        emptyLabelStackView.addArrangedSubviews(emptyPlanLabel, planSettingLabel)
        
        summaryScrollerView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(summaryScrollerView.contentLayoutGuide)
            $0.width.equalTo(summaryScrollerView.frameLayoutGuide)
            /// 기기별로 높이 어떻게 줄 건지...
            $0.height.equalTo(convertByWidthRatio(810))
        }
        
        naviView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(66)
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
            $0.height.width.equalTo(40)
        }
        
        summaryLabel.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }
        
        settingButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.height.width.equalTo(40)
        }
        
        mySmeemLabel.snp.makeConstraints {
            $0.top.equalTo(naviView.snp.bottom).offset(18)
            $0.leading.equalToSuperview().inset(26)
        }
        
        mySmeemView.snp.makeConstraints {
            $0.top.equalTo(mySmeemLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(82)
        }
        
        mySmeemCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        myPlanLabel.snp.makeConstraints {
            $0.top.equalTo(mySmeemView.snp.bottom).offset(36)
            $0.leading.equalToSuperview().inset(26)
        }
        
        myPlanView.snp.makeConstraints {
            $0.top.equalTo(myPlanLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(120)
        }
        
        myPlanTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.leading.equalToSuperview().inset(17)
        }
        
        myPlanDetailLabel.snp.makeConstraints {
            $0.top.equalTo(myPlanTitleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(myPlanTitleLabel)
        }
        
        myPlanCollectionView.snp.makeConstraints {
            $0.top.equalTo(myPlanDetailLabel.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.top.equalTo(myPlanLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(120)
        }
        
        emptyLabelStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        myBadgeLabel.snp.makeConstraints {
            $0.top.equalTo(myPlanLabel.snp.bottom).offset(178)
            $0.leading.equalToSuperview().inset(26)
        }
        
        myBadgeCollectionView.snp.makeConstraints {
            $0.top.equalTo(myBadgeLabel.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func registerCell() {
        mySmeemCollectionView.registerCell(cellType: MySmeemCollectionViewCell.self)
        myPlanCollectionView.registerCell(cellType: MyPlanCollectionViewCell.self)
        myBadgeCollectionView.registerCell(cellType: MyBadgeCollectionViewCell.self)
    }
    
    private func setDelegate() {
        mySmeemCollectionView.delegate = self
//        mySmeemCollectionView.dataSource = self
        
        myPlanCollectionView.delegate = self
        myPlanCollectionView.dataSource = self
        
        myBadgeCollectionView.delegate = self
        myBadgeCollectionView.dataSource = self
    }
}

extension MySummaryViewController: UICollectionViewDelegateFlowLayout { }

extension MySummaryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.myPlanCollectionView {
            return 7
        } else if collectionView == self.myBadgeCollectionView {
            return 9
        }
        
        return Int()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.myPlanCollectionView {
            let cell = self.myPlanCollectionView.dequeueReusableCell(cellType: MyPlanCollectionViewCell.self,
                                                                     indexPath: indexPath)
            cell.setNumberData(text: myPlanDataArray[indexPath.item])
            cell.deactivateCell()
            return cell
        } else if collectionView == self.myBadgeCollectionView {
            let cell = self.myBadgeCollectionView.dequeueReusableCell(cellType: MyBadgeCollectionViewCell.self,
                                                                      indexPath: indexPath)
//            if indexPath.item == 1 {
//                cell.setBadgeLayout()
//            } else {
//                cell.setLayout()
//            }
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.mySmeemCollectionView {
            let leadingTrailingInset = 90.0
            let itemSpacing = 60.0
            let cellCount = 4.0
            return CGSize(width: (Constant.Screen.width-(leadingTrailingInset+itemSpacing))/cellCount,
                          height: 46)
        } else if collectionView == self.myPlanCollectionView {
            let leadingTrailingInset = 73.0
            let itemSpacing = 162.0
            let cellCount = 7.0
            return CGSize(width: (UIScreen.main.bounds.width-(leadingTrailingInset+itemSpacing))/cellCount,
                          height: (UIScreen.main.bounds.width-(leadingTrailingInset+itemSpacing))/cellCount)
        } else if collectionView == self.myBadgeCollectionView {
            let leadingTrailingInset = 36.0
            let itemSpacing = 16.0
            let cellCount = 3.0
            print((UIScreen.main.bounds.width-(leadingTrailingInset+itemSpacing))/cellCount)
            return CGSize(width: (UIScreen.main.bounds.width-(leadingTrailingInset+itemSpacing))/cellCount,
                          height: (UIScreen.main.bounds.width-(leadingTrailingInset+itemSpacing))/cellCount)
        }
        return CGSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        /// 왜 20 아니냐...
        if collectionView == self.mySmeemCollectionView {
            return 10.0
        } else if collectionView == self.myPlanCollectionView {
            return 27.0
        } else if collectionView == self.myBadgeCollectionView {
            return 8.0
        }
        
        return CGFloat()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.myBadgeCollectionView {
            return 8.0
        }
        
        return CGFloat()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == self.mySmeemCollectionView {
            return UIEdgeInsets(top: 18, left: 27, bottom: 18, right: 28)
        } else if collectionView == self.myBadgeCollectionView {
            return UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 17)
        }
        
        return UIEdgeInsets()
    }
}
