//
//  StepOneKoreanDiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/05.
//

import UIKit

import SnapKit

final class StepOneKoreanDiaryViewController: DiaryViewController {
    
    // MARK: - Property
    
    weak var delegate: DataBindProtocol?
    
    private let tipView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    private let tipLabel: UILabel = {
        let label = UILabel()
        label.text = "TIP"
        label.font = .c3
        label.textColor = .point
        return label
    }()
    
    private let tipContentsLabel: UILabel = {
        let label = UILabel()
        label.text = "문장을 정리하면 다음 단계에서 더욱 정확한 힌트를\n받을 수 있어요!"
        label.font = .c3
        label.textColor = .gray600
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var cancelTipButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnCancelGrey, for: .normal)
        button.addTarget(self, action: #selector(cancelTipButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkTipView()
    }
    
    // MARK: - @objc
    
    override func leftNavigationButtonDidTap() {
        handleLeftNavigationButton()
    }
    
    override func rightNavigationButtonDidTap() {
        if rightNavigationButton.titleLabel?.textColor == .point {
            handleRightNavigationButton()
        } else {
            showToastIfNeeded(toastType: .defaultToast(bodyType: .regEx))
        }
    }
    
    @objc func cancelTipButtonDidTap() {
        UserDefaultsManager.tipView = true
        tipView.removeFromSuperview()
    }
    
    // MARK: - Custom Method
    
    private func handleLeftNavigationButton() {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    private func handleRightNavigationButton() {
        let stepTwoVC = StepTwoKoreanDiaryViewController()
        delegate = stepTwoVC
        
        if let text = self.inputTextView.text {
            delegate?.dataBind(text: text)
        }
        
        self.navigationController?.pushViewController(stepTwoVC, animated: true)
    }
    
    override func updateAdditionalViewsForKeyboard(notification: NSNotification, keyboardHeight: CGFloat) {
        self.tipView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
    }
    
    // MARK: - Layout
    
    private func checkTipView() {
        if !UserDefaultsManager.tipView {
            if let randomSubjectToolTip = randomSubjectToolTip {
                view.insertSubview(tipView, belowSubview: randomSubjectToolTip)
            } else {
                view.addSubview(tipView)
            }
            
            tipView.addSubviews(tipLabel, tipContentsLabel, cancelTipButton)
            
            tipView.snp.makeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(thinLine.snp.top)
                $0.height.equalTo(convertByHeightRatio(62))
            }
            
            tipLabel.snp.makeConstraints {
                $0.top.equalToSuperview().offset(convertByHeightRatio(14))
                $0.leading.equalToSuperview().offset(convertByWidthRatio(18))
            }
            
            tipContentsLabel.snp.makeConstraints {
                $0.top.equalTo(tipLabel)
                $0.leading.equalTo(tipLabel.snp.trailing).offset(convertByWidthRatio(10))
            }
            
            cancelTipButton.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(convertByWidthRatio(4))
                $0.centerY.equalToSuperview()
            }
            
        } else {
            // 아래 두 줄을 추가하여 tipView가 추가되지 않을 때 thinLine.bottom의 제약 조건을 설정해 주세요.
            thinLine.snp.remakeConstraints {
                $0.height.equalTo(1)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(bottomView.snp.top)
            }
        }
    }
}
