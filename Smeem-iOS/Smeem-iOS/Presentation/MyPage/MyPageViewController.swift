//
//  MyPageViewController.swift
//  Smeem-iOS
//
//  Created by 임주민 on 2023/06/27.
//

import UIKit

import SnapKit

final class MyPageViewController: UIViewController {
    
    // MARK: - Property
    
    // MARK: - UI Property
    
    private let headerContainerView = UIView()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnBack, for: .normal)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "마이 페이지"
        label.font = .s2
        label.textColor = .smeemBlack
        return label
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnMoreHoriz, for: .normal)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setLayout()
    }
    
    // MARK: - @objc
    
    // MARK: - Custom Method
    
    // MARK: - Layout
    
    private func setBackgroundColor() {
        view.backgroundColor = .white
    }
    
    private func setLayout() {
        setBackgroundColor()
        hiddenNavigationBar()
        
        view.addSubviews(headerContainerView)
        headerContainerView.addSubviews(backButton, titleLabel)
        
        headerContainerView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(convertByHeightRatio(66))
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.width.height.equalTo(45)
        }
        
        titleLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(10)
            $0.width.height.equalTo(45)
        }
        
    }
}
