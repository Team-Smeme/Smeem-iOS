//
//  MySummaryViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 4/22/24.
//

import UIKit
import SnapKit

final class MySummaryViewController: BaseViewController {
    
    private let mySmeemModel = ["방문일", "총 일기", "연속 일기", "배지"]
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        registerCell()
        setDelegate()
    }
    
    private func setLayout() {
        view.addSubview(summaryScrollerView)
        summaryScrollerView.addSubview(contentView)
        contentView.addSubviews(naviView, mySmeemLabel, mySmeemView)
        naviView.addSubviews(backButton, summaryLabel, settingButton)
        mySmeemView.addSubview(mySmeemCollectionView)
        
        summaryScrollerView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(summaryScrollerView.contentLayoutGuide)
            $0.width.equalTo(summaryScrollerView.frameLayoutGuide)
            $0.height.equalTo(1000)
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
            $0.leading.equalToSuperview().inset(18)
        }
        
        mySmeemView.snp.makeConstraints {
            $0.top.equalTo(mySmeemLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(82)
        }
        
        mySmeemCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func registerCell() {
        mySmeemCollectionView.registerCell(cellType: MySmeemCollectionViewCell.self)
    }
    
    private func setDelegate() {
        mySmeemCollectionView.delegate = self
        mySmeemCollectionView.dataSource = self
    }
}

extension MySummaryViewController: UICollectionViewDelegateFlowLayout {
    
//    func colld
    
}

extension MySummaryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.mySmeemCollectionView {
            return mySmeemModel.count
        }
        
        return Int()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.mySmeemCollectionView {
            let cell = self.mySmeemCollectionView.dequeueReusableCell(cellType: MySmeemCollectionViewCell.self,
                                                                      indexPath: indexPath)
            cell.setTextData(text: mySmeemModel[indexPath.item])
            cell.setNumberData(number: "23")
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.mySmeemCollectionView {
            let leadingTrailingInset = 90.0
            let itemSpacing = 60.0
            let cellCount = 4.0
            return CGSize(width: (UIScreen.main.bounds.width-(leadingTrailingInset+itemSpacing))/cellCount,
                          height: 46)
        }
        return CGSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        /// 왜 20 아니냐...
        if collectionView == self.mySmeemCollectionView {
            return 10.0
        }
        return CGFloat()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == self.mySmeemCollectionView {
            return UIEdgeInsets(top: 18, left: 27, bottom: 18, right: 28)
        }
        return UIEdgeInsets()
    }
}
