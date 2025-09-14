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
    
    private let diaryViewControllerFactory = DiaryViewControllerFactory(diaryViewFactory: DiaryViewFactory())
    
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
        return koreanButton
    }()
    
    private lazy var floatingButton: UIButton = {
        let myPageButton = UIButton()
        myPageButton.setImage(Constant.Image.cancelButton, for: .normal)
        myPageButton.addTarget(self, action: #selector(self.floatingButtonDidTap(_:)), for: .touchUpInside)
        return myPageButton
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
    
    private lazy var foreginTouchBackView: UIView = {
        let backView = UIView()
        backView.backgroundColor = .clear
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(foreignDiaryButtonDidTap(_:)))
        backView.addGestureRecognizer(tapGesture)
        backView.isUserInteractionEnabled = true
        return backView
    }()
    
    private lazy var koreanTouchBackView: UIView = {
        let backView = UIView()
        backView.backgroundColor = .clear
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(koreanDiaryButtonDidTap(_:)))
        backView.addGestureRecognizer(tapGesture)
        backView.isUserInteractionEnabled = true
        return backView
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        setLayout()
    }
    
    // MARK: - Layout
    
    private func setBackgroundColor() {
        view.backgroundColor = .clear
    }
    
    private func setLayout() {
        view.addSubviews(dimView, floatingButton, buttonStackView, foreginTouchBackView, koreanTouchBackView)
        buttonStackView.addArrangedSubviews(foreignDiaryButton, border, koreanDiaryButton)
        
        dimView.snp.makeConstraints {
            $0.top.trailing.bottom.leading.equalToSuperview()
        }
        
        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 49  // 기본값 49
        let bottomInset = view.safeAreaInsets.bottom > 0 ? view.safeAreaInsets.bottom : 34 // 홈 인디케이터 대응
        
        floatingButton.snp.makeConstraints {
            $0.width.height.equalTo(convertByWidthRatio(54))
            $0.trailing.equalToSuperview().inset(18)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(tabBarHeight + 16 + bottomInset - 34)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.bottom.equalTo(floatingButton.snp.top).offset(-10)
            $0.trailing.equalToSuperview().inset(18)
            $0.height.equalTo(constraintByNotch(118, 130))
            $0.width.equalTo(convertByWidthRatio(197))
        }
        
        border.snp.makeConstraints {
            $0.height.equalTo(convertByHeightRatio(2))
            $0.width.equalTo(convertByWidthRatio(331))
        }
        
        foreginTouchBackView.snp.makeConstraints {
            $0.top.equalTo(buttonStackView.snp.top)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(buttonStackView.snp.width)
            $0.height.equalTo(constraintByNotch(118, 130) / 2)
        }
        
        koreanTouchBackView.snp.makeConstraints {
            $0.bottom.equalTo(buttonStackView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(buttonStackView.snp.width)
            $0.height.equalTo(constraintByNotch(118, 130) / 2)
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
        AmplitudeManager.shared.track(event: AmplitudeConstant.diary.for_writing_click.event)
        let nextVC = diaryViewControllerFactory.makeForeignDiaryViewController()
        let navigationController = UINavigationController(rootViewController: nextVC)
        navigationController.modalTransitionStyle = .coverVertical
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    @objc func koreanDiaryButtonDidTap(_ gesture: UITapGestureRecognizer) {
        AmplitudeManager.shared.track(event: AmplitudeConstant.diary.kor_writing_click.event)
        let nextVC = diaryViewControllerFactory.makeStepOneKoreanDiaryViewController()
        let navigationController = UINavigationController(rootViewController: nextVC)
        navigationController.modalTransitionStyle = .coverVertical
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    @objc func dismissButtonDidTap() {
        tutorialImageView?.removeFromSuperview()
        dismissButton?.removeFromSuperview()
    }
}
