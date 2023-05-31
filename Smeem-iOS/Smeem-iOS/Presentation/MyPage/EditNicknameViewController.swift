//
//  EditNicknameViewController.swift
//  Smeem-iOS
//
//  Created by JH on 2023/05/31.
//

import UIKit

import SnapKit

class EditNicknameViewController: UIViewController {
    
    // MARK: - Property
    
    // MARK: - UI Property
    
    private let headerContainerView = UIView()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPink
        return button
    }()
//        setImage, addTarget 넣기
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임 변경"
        label.font = .s2
        label.textColor = .smeemBlack
        return label
    }()

    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        setLayout()
        hiddenNavigationBar()
//        showKeyboard(textView: nicknameTextField)
    }

    // MARK: - @objc
    
    // MARK: - Custom Method
    
    // MARK: - Layout
 
    private func setBackgroundColor() {
        view.backgroundColor = .smeemWhite
    }
    
    private func setLayout() {
        view.addSubviews(headerContainerView)
        headerContainerView.addSubviews(backButton, titleLabel)
        
        headerContainerView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(66)
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.width.height.equalTo(45)
        }
        
        titleLabel.snp.makeConstraints{
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    

}

// MARK: - UITableView Delegate
