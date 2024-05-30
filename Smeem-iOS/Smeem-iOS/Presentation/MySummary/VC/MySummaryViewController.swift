//
//  MySummaryViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 4/22/24.
//

import UIKit
import SnapKit
import Combine

enum SummaryAmplitudeType {
    case viewDidLoad
    case badge(String, Bool)
}

final class MySummaryViewController: BaseViewController, BottomSheetPresentable {
    
    // MARK: Publisher
    
    private let mySummarySubject = PassthroughSubject<Void, Never>()
    private let myPlanSubject = PassthroughSubject<Void, Never>()
    private let myBadgeSubject = PassthroughSubject<Void, Never>()
    private let badgeCellTapped = PassthroughSubject<Int, Never>()
    private let amplitudeSubject = PassthroughSubject<SummaryAmplitudeType, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    private var mySmeemDataSource: MySmeemCollectionViewDataSource!
    private var myPlanFlowLayout: MyPlanCollectionViewLayout!
    private var myPlanDataSource: MyPlanCollectionViewDataSource!
    private var myBadgeDataSource: MyBadgeCollectionViewDatasource!
    
    private let viewModel = MySummaryViewModel(provider: MySummaryService())
    
    // MARK: UI Properties
    
    private let summaryScrollerView: UIScrollView = {
        let scrollerView = UIScrollView()
        scrollerView.showsVerticalScrollIndicator = false
        return scrollerView
    }()
    
    private let contentView = UIView()
    private let naviView = UIView()
    private let emptyContainerView = UIView()
    
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
        button.titleLabel?.font = .b2
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
        collectionView.backgroundColor = .smeemWhite
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
        view.backgroundColor = .smeemWhite
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray100.cgColor
        view.isHidden = true
        return view
    }()
    
    private let myPlanTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "매일 일기 작성하기"
        label.font = .b2
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
        view.backgroundColor = .smeemWhite
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
        label.font = .c2
        label.textColor = .gray400
        
        let attributedString = NSMutableAttributedString(string: "플랜 설정하러 가기")
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString
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
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        registerCell()
        setDelegate()
        bind()
        amplitudeSubject.send(.viewDidLoad)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        mySummarySubject.send(())
        myPlanSubject.send(())
        myBadgeSubject.send(())
    }
    
    override func setBackgroundColor() {
        view.backgroundColor = .summaryBackground
    }
    
    // MARK: - Method
    
    private func bind() {
        backButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancelBag)
        
        settingButton.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let authVC = SettingViewController()
                self?.navigationController?.pushViewController(authVC, animated: true)
            }
            .store(in: &cancelBag)
        
        emptyContainerView.gesturePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let editVC = EditPlanViewController()
                editVC.toastSubject
                    .sink { [weak self] _ in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            self?.showToast(toastType: .smeemToast(bodyType: .changed))
                        }
                    }
                    .store(in: &editVC.cancelBag)
                self?.navigationController?.pushViewController(editVC, animated: true)
            }
            .store(in: &cancelBag)
        
        let input = MySummaryViewModel.Input(mySummarySubject: mySummarySubject,
                                             myPlanSubject: myPlanSubject,
                                             myBadgeSubject: myBadgeSubject,
                                             badgeCellTapped: badgeCellTapped,
                                             amplitudeSubject: amplitudeSubject)
        let output = viewModel.transform(input: input)
        
        output.totalHasMyPlanResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                self?.myPlanView.isHidden = false
                self?.myPlanCollectionView.isHidden = false
                self?.emptyView.isHidden = true
                
                self?.mySmeemDataSource = MySmeemCollectionViewDataSource(numberItems: response.mySummaryNumber,
                                                                          textItems: response.mySumamryText)
                self?.mySmeemCollectionView.dataSource = self?.mySmeemDataSource
                self?.mySmeemCollectionView.reloadData()
                
                self?.myPlanFlowLayout = MyPlanCollectionViewLayout(cellCount: response.myPlan!.clearCount.count)
                self?.myPlanDataSource = MyPlanCollectionViewDataSource(planNumber: response.myPlan!.clearedCount,
                                                                        totalNumber: response.myPlan!.clearCount)
                self?.myPlanTitleLabel.text = response.myPlan?.plan
                
                self?.myPlanCollectionView.dataSource = self?.myPlanDataSource
                self?.myPlanCollectionView.delegate = self?.myPlanFlowLayout
                self?.remakePlanLayout(number: response.myPlan?.clearCount.count)
                self?.myPlanCollectionView.reloadData()
                
                self?.myBadgeDataSource = MyBadgeCollectionViewDatasource(badgeData: response.myBadge)
                self?.myBadgeCollectionView.dataSource = self?.myBadgeDataSource
                self?.myBadgeCollectionView.reloadData()
            }
            .store(in: &cancelBag)
        
        output.totalHasNotPlanResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                self?.myPlanView.isHidden = true
                self?.myPlanCollectionView.isHidden = true
                self?.emptyView.isHidden = false

                self?.mySmeemDataSource = MySmeemCollectionViewDataSource(numberItems: response.mySummaryNumber,
                                                                          textItems: response.mySumamryText)
                self?.mySmeemCollectionView.dataSource = self?.mySmeemDataSource
                self?.mySmeemCollectionView.reloadData()
                
                self?.remakePlanLayout(number: nil)
                
                self?.myBadgeDataSource = MyBadgeCollectionViewDatasource(badgeData: response.myBadge)
                self?.myBadgeCollectionView.dataSource = self?.myBadgeDataSource
                self?.myBadgeCollectionView.reloadData()
            }
            .store(in: &cancelBag)
        
        output.badgeCellResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                let badgeBottomSheetVC = BadgeBottomSheetViewController()
                badgeBottomSheetVC.setData(data: response)
                self?.amplitudeSubject.send(.badge(response.type, response.hasBadge))
                self?.presentBottomSheet(viewController: badgeBottomSheetVC)
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
        view.addSubviews(naviView, summaryScrollerView)
        naviView.addSubviews(backButton, summaryLabel, settingButton)
        summaryScrollerView.addSubview(contentView)
        contentView.addSubviews(mySmeemLabel, mySmeemView,
                                myPlanLabel, myPlanView, emptyView,
                                myBadgeLabel, myBadgeCollectionView)
        mySmeemView.addSubview(mySmeemCollectionView)
        myPlanView.addSubviews(myPlanTitleLabel, myPlanCollectionView)
        emptyView.addSubviews(emptyContainerView)
        emptyContainerView.addSubview(emptyLabelStackView)
        emptyLabelStackView.addArrangedSubviews(emptyPlanLabel, planSettingLabel)
        
        naviView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
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
        
        summaryScrollerView.snp.makeConstraints {
            $0.top.equalTo(naviView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(summaryScrollerView.frameLayoutGuide)
            $0.height.equalTo(convertByWidthRatio(835))
        }
        
        mySmeemLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
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
        
        emptyContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.height.equalTo(emptyView)
        }
    
        emptyView.snp.makeConstraints {
            $0.top.equalTo(myPlanLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(120)
        }
    
        emptyLabelStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        myPlanView.snp.makeConstraints {
            $0.top.equalTo(myPlanLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(91)
        }
        
        myPlanTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.leading.equalToSuperview().inset(17)
        }
        
        myPlanCollectionView.snp.makeConstraints {
            $0.top.equalTo(myPlanTitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview()
        }
        
        myBadgeLabel.snp.makeConstraints {
            $0.top.equalTo(myPlanLabel.snp.bottom).offset(139)
            $0.leading.equalToSuperview().inset(26)
        }
        
        myBadgeCollectionView.snp.makeConstraints {
            $0.top.equalTo(myBadgeLabel.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func registerCell() {
        mySmeemCollectionView.registerCell(cellType: MySmeemCollectionViewCell.self)
        myPlanCollectionView.registerCell(cellType: MyPlanActiveCollectionViewCell.self)
        myPlanCollectionView.registerCell(cellType: MyPlanDeactiveCollectionViewCell.self)
        myBadgeCollectionView.registerCell(cellType: MyBadgeCollectionViewCell.self)
        myBadgeCollectionView.registerCell(cellType: LockBadgeCollectionViewCell.self)
    }
    
    private func setDelegate() {
        mySmeemCollectionView.delegate = self
        myBadgeCollectionView.delegate = self
    }
    
    private func remakePlanLayout(number: Int?) {
        switch number {
            case nil:
            myBadgeLabel.snp.updateConstraints {
                $0.top.equalTo(myPlanLabel.snp.bottom).offset(178)
            }
            
            case 1:
            myPlanView.snp.updateConstraints {
                $0.height.equalTo(56)
            }
            
            myPlanCollectionView.snp.remakeConstraints {
                $0.top.bottom.equalToSuperview().inset(18)
                $0.trailing.equalToSuperview().inset(17)
                $0.width.equalTo(20)
            }
            
            myBadgeLabel.snp.updateConstraints {
                $0.top.equalTo(myPlanLabel.snp.bottom).offset(104)
            }
            
            case 3:
            let widthRatio = (Constant.Screen.width-36)/3
            
            myPlanView.snp.updateConstraints {
                $0.height.equalTo(56)
            }
            
            myPlanCollectionView.snp.remakeConstraints {
                $0.top.bottom.equalToSuperview().inset(18)
                $0.trailing.equalToSuperview().inset(17)
                $0.width.equalTo(widthRatio)
            }
            
            myBadgeLabel.snp.updateConstraints {
                $0.top.equalTo(myPlanLabel.snp.bottom).offset(104)
            }
            
            case 5, 7:
            myPlanView.snp.updateConstraints {
                $0.height.equalTo(91)
            }
            
            myPlanCollectionView.snp.remakeConstraints {
                $0.top.equalTo(myPlanTitleLabel.snp.bottom).offset(16)
                $0.leading.trailing.equalToSuperview().inset(18)
                $0.bottom.equalToSuperview()
            }
            
            myBadgeLabel.snp.updateConstraints {
                $0.top.equalTo(myPlanLabel.snp.bottom).offset(139)
            }
            
            default: break;
        }
    }
}

extension MySummaryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.myBadgeCollectionView {
            self.badgeCellTapped.send(indexPath.item)
        }
    }
}

extension MySummaryViewController {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.mySmeemCollectionView {
            let leadingTrailingInset = 90.0
            let itemSpacing = 60.0
            let cellCount = 4.0
            return CGSize(width: (Constant.Screen.width-(leadingTrailingInset+itemSpacing))/cellCount,
                          height: 46)
        } else if collectionView == self.myBadgeCollectionView {
            let leadingTrailingInset = 36.0
            let itemSpacing = 16.0
            let cellCount = 3.0
            return CGSize(width: (UIScreen.main.bounds.width-(leadingTrailingInset+itemSpacing))/cellCount,
                          height: (UIScreen.main.bounds.width-(leadingTrailingInset+itemSpacing))/cellCount)
        }
        return CGSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.mySmeemCollectionView {
            return 10.0
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
