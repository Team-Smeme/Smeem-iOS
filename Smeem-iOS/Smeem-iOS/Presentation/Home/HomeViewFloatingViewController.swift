//
//  HomeViewFloatingViewController.swift
//  Smeem-iOS
//
//  Created by 임주민 on 2023/05/31.
//

import UIKit

import SnapKit

final class HomeViewFloatingViewController: UIViewController {
    
    // MARK: - Property
    
    // MARK: - UI Property
    
    private let buttonStackView: UIStackView = {
        let backView = UIStackView()
        backView.backgroundColor = .smeemWhite
        backView.distribution = .equalSpacing
        backView.alignment = .center
        backView.axis = .vertical
        backView.spacing = 18
        backView.isLayoutMarginsRelativeArrangement = true
        backView.layoutMargins.top = 20
        backView.layoutMargins.bottom = 20
        backView.layer.cornerRadius = 6
        return backView
    }()
    
    private lazy var foreignDiaryButton: UILabel = {
        let foreignButton = UILabel()
        foreignButton.font = .s4
        foreignButton.attributedText = changePartialStringStyle(mainString: "외국어로 바로 작성하기", pointString: "외국어로 바로", pointFont: .s2, pointColor: .point)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(foreignDiaryButtonDidTap(_:)))
        foreignButton.addGestureRecognizer(tapGesture)
        foreignButton.isUserInteractionEnabled = true
        return foreignButton
    }()
    
    private let border: UIView = {
        let border = UIView()
        border.backgroundColor = .gray100
        return border
    }()
    
    private lazy var koreanDiaryButton: UILabel = {
        let koreanButton = UILabel()
        koreanButton.font = .s4
        koreanButton.attributedText = changePartialStringStyle(mainString: "한국어로 먼저 작성하기", pointString: "한국어로 먼저", pointFont: .s2, pointColor: .point)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(koreanDiaryButtonDidTap(_:)))
        koreanButton.addGestureRecognizer(tapGesture)
        koreanButton.isUserInteractionEnabled = true
        return koreanButton
    }()
    
    private lazy var floatingButton: SmeemButton = {
        let floatingButton = SmeemButton()
        floatingButton.smeemButtonType = .enabled
        floatingButton.setTitle("취소", for: .normal)
        floatingButton.addTarget(self, action: #selector(self.floatingButtonDidTap(_:)), for: .touchUpInside)
        return floatingButton
    }()
    
    private lazy var dimView: UIView = {
        let dimView = UIView()
        dimView.backgroundColor = UIColor(red: 0.09, green: 0.09, blue: 0.086, alpha: 0.3)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dimViewDidTap(_:)))
        dimView.addGestureRecognizer(tapGesture)
        dimView.isUserInteractionEnabled = true
        return dimView
    }()
    
    private var tutorialImageView: UIImageView? = {
        let imageView = UIImageView()
        imageView.image = Constant.Image.tutorialWeekly
        return imageView
    }()
    
    private lazy var dismissButton: UIButton? = {
        let button = UIButton()
        button.addTarget(self, action: #selector(dismissButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        setLayout()
//        checkTutorial()
    }
    
    // MARK: - Custom Method
    
    private func checkTutorial() {
//        let tutorialDiaryStepTwo = UserDefaultsManager.tutorialWeeklyTwoMode
//
//        if !tutorialDiaryStepTwo {
//            UserDefaultsManager.tutorialWeeklyTwoMode = true
//
//            view.addSubviews(tutorialImageView ?? UIImageView(), dismissButton ?? UIButton())
//
//            tutorialImageView?.snp.makeConstraints {
//                $0.top.leading.trailing.bottom.equalToSuperview()
//            }
//            dismissButton?.snp.makeConstraints {
//                $0.top.equalToSuperview().inset(convertByHeightRatio(503))
//                $0.trailing.equalToSuperview().inset(convertByHeightRatio(10))
//                $0.width.height.equalTo(convertByHeightRatio(45))
//            }
//        } else {
//            tutorialImageView = nil
//            dismissButton = nil
//        }
    }
    
    
    // MARK: - Layout
    
    private func setBackgroundColor() {
        view.backgroundColor = .clear
    }
    
    private func setLayout() {
        view.addSubviews(dimView, floatingButton, buttonStackView)
        buttonStackView.addArrangedSubviews(foreignDiaryButton, border, koreanDiaryButton)
        
        dimView.snp.makeConstraints {
            $0.top.trailing.bottom.leading.equalToSuperview()
        }
        
        floatingButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(convertByHeightRatio(50))
            $0.centerX.equalToSuperview()
            $0.width.equalTo(convertByWidthRatio(339))
            $0.height.equalTo(convertByHeightRatio(60))
        }
        
        buttonStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-convertByHeightRatio(118))
            $0.centerX.equalToSuperview()
            $0.height.equalTo(convertByHeightRatio(118))
            $0.width.equalTo(convertByWidthRatio(339))
        }
        
        border.snp.makeConstraints {
            $0.height.equalTo(convertByHeightRatio(2))
            $0.width.equalTo(convertByWidthRatio(331))
        }
    }
    
    // MARK: - @objc
    
    @objc func dimViewDidTap(_ gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func floatingButtonDidTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func foreignDiaryButtonDidTap(_ gesture: UITapGestureRecognizer) {
        let nextVC = ForeignDiaryViewController()
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true)
    }
    
    @objc func koreanDiaryButtonDidTap(_ gesture: UITapGestureRecognizer) {
        let nextVC = StepOneKoreanDiaryViewController()
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true)
    }
    
    @objc func dismissButtonDidTap() {
        tutorialImageView?.removeFromSuperview()
        dismissButton?.removeFromSuperview()
    }
}
