//
//  StepTwoKoreanDiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/05.
//

import UIKit

import SnapKit

final class StepTwoKoreanDiaryViewController: DiaryViewController {
    
    // MARK: - Property
    
    // MARK: - UI Property
    
    private let hintTextView: UITextView = {
        let textView = UITextView()
        textView.font = .b4
        textView.textContainerInset = .init(top: 16, left: 18, bottom: 16, right: 38)
        textView.scrollIndicatorInsets = .init(top: 16, left: 0, bottom:16, right: 18)
        //TODO: 텍스트뷰 인셋 구현
        textView.text = "오늘은 OPR을 공개한 날이었다. 안 떨릴 줄 알았는데 겁나 떨렸당. 사실 카페가 추웠어서 추워서 떠는 건지 긴장 돼서 떠는 건지 구분이 잘 안 갔다. 근데 사실 나는 다리 떠는 것도 습관이라 다리를 떨어서 블라블라블라블라블라블라블라블ㄹ라블라블라블라블라블라블라블라블ㄹ라"
        textView.setLineSpacing()
        return textView
    }()
    
    private let thickLine = SeparationLine(height: .thick)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
    }
    
    // MARK: - @objc
    
    // MARK: - Custom Method
    
    // MARK: - Layout
    
    private func setLayout() {
        view.addSubviews(hintTextView,thickLine)
        
        hintTextView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(convertByHeightRatio(120))
        }
        
        //TODO: ThicklineColor = g100
        thickLine.snp.makeConstraints {
            $0.top.equalTo(hintTextView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        inputTextView.snp.remakeConstraints {
            //TODO: 수정 필요?
            $0.top.equalTo(thickLine.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(bottomView.snp.top)
        }
    }
}
