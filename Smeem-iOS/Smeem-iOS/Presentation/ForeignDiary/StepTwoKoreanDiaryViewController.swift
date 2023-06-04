//
//  StepTwoKoreanDiaryViewController.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/06/05.
//

import UIKit

final class StepTwoKoreanDiaryViewController: DiaryViewController {
    
    private let hintTextView: UITextView = {
        let textView = UITextView()
        textView.font = .b4
        textView.setLineSpacing()
        //TODO: 텍스트뷰 인셋 구현
        textView.text = "오늘은 OPR을 공개한 날이었다. 안 떨릴 줄 알았는데 겁나 떨렸당. 사실 카페가 추웠어서 추워서 떠는 건지 긴장 돼서 떠는 건지 구분이 잘 안 갔다. 근데 사실 나는 다리 떠는 것도 습관이라 다리를 떨어서 "
        return textView
    }()
    
    private let thickLine = SeparationLine(height: .thick)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextView()
        setLayout()
    }
    
    private func setupTextView() {
        view.addSubview(hintTextView)
        
        hintTextView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(convertByWidthRatio(18))
            $0.trailing.equalToSuperview().offset(-convertByWidthRatio(18))
            $0.height.equalTo(convertByHeightRatio(88))
        }
    }
    
    private func setLayout() {
        view.addSubviews(thickLine)
        thickLine.snp.makeConstraints {
            $0.top.equalTo(hintTextView.snp.bottom)
            $0.centerX.equalToSuperview()
//            $0.leading.equalToSuperview()
        }
        
        inputTextView.snp.remakeConstraints {
            $0.top.equalTo(thickLine.snp.bottom)
            $0.leading.trailing.equalToSuperview().offset(18)
            $0.bottom.equalTo(bottomView.snp.top)
        }
        
        
    }
}
