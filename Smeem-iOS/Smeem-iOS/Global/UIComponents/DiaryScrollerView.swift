//
//  DiaryScrollerView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/20.
//

/**
 1. VC에서 생성시 type 정해 주기. 첨삭 일기일 경우 .correction, 랜덤 주제가 있을 경우 correctionHasRandomSubject
 그냥 일기 상세일 경우 detailDiary, 랜덤 주제 있을 경우 detatilDiaryHasRandomSubject
 
 private let diaryScrollerView: DiaryScrollerView = {
     let scrollerView = DiaryScrollerView()
     scrollerView.viewType = .detailDiary
     return scrollerView
 }()
 
 2. 일기 줄수의 높이에 따라 내부 contentView의 높이가 동적으로 계산되기 때문에, 레이아웃만 설정해 주면 됨.
 
 diaryScrollerView.snp.makeConstraints {
     $0.top.leading.trailing.bottom.equalToSuperview()
 }
 */

import UIKit

import SnapKit

final class DiaryScrollerView: UIScrollView {
    
    // MARK: - Property
    
    enum ViewType {
        case correction
        case correctionHasRandomSubject
        case detailDiary
        case detailDiaryHasRandomSubject
    }
    
    var viewType: ViewType = .correction {
        didSet {
            viewTypeContentViewLayout()
            setDelegate()
        }
    }
    
    // MARK: - UI Property
    
    private let contentView = UIView()
    
    private let correnctionLabel: UILabel = {
        let label = UILabel()
        label.text = "TIP 첨삭할 부분을 드래그 해보세요!"
        label.font = .c3
        label.textColor = .point
        label.asColor(targetString: "첨삭할 부분을 드래그 해보세요!", color: .gray500)
        return label
    }()
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.font = .b4
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.text = "I watched Avatar with my boyfriend at Hongdae CGV. I should have skimmed the previous season - Avatar1.. I really couldn’t get what they were saying and the universe(??). What I was annoyed then was 두팔 didn’t know that as me. I think 두팔 who is my boyfriend should study before wathcing…. but Avatar2 is amazing movie I think. In my personal opinion, the jjin main character of Avatar2 is not Sully, but his son. "
        textView.tintColor = .point
        textView.configureAttributedText()
        return textView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "2023년 3월 27일 4:18 PM"
        label.font = .c3
        label.textColor = .gray500
        return label
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "유진이"
        label.font = .c3
        label.textColor = .black
        return label
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        stackView.alignment = .trailing
        return stackView
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setBackgroundColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - @objc
    
    // MARK: - Custom Method
    
    func configureDiaryScrollerView(contentText: String, date: String, nickname: String) {
        contentTextView.text = contentText
        dateLabel.text = date
        nicknameLabel.text = nickname
        contentTextView.configureAttributedText()
    }
    
    private func calculateTextViewHeight(textView: UITextView) -> CGFloat {
        textView.frame = CGRect(x: 0,
                                y: 0,
                                width: 339,
                                height: CGFloat.greatestFiniteMagnitude)
        
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        textView.frame.size.height = newSize.height
        
        return ceil(newSize.height)
    }
    
    private func setDelegate() {
        switch viewType {
        case .correction, .correctionHasRandomSubject:
            contentTextView.delegate = self
        case .detailDiary, .detailDiaryHasRandomSubject: break
        }
    }
        
    // MARK: - Layout
        
    private func setBackgroundColor() {
        backgroundColor = .white
    }
        
    private func viewTypeContentViewLayout() {
        let detailDiaryTopInset: CGFloat = 16
        let detailbottomInset: CGFloat = 78
        let correctionTopInset: CGFloat = 41
        let correctionbottomInset: CGFloat = 78
            
        let detailDiaryTotalContentViewHeight = detailDiaryTopInset+detailbottomInset+calculateTextViewHeight(textView: contentTextView)
        let correctiontextViewTotalHeight = correctionTopInset+correctionbottomInset+calculateTextViewHeight(textView: contentTextView)
            
        addSubview(contentView)
        contentView.addSubviews(correnctionLabel, contentTextView, labelStackView)
        labelStackView.addArrangedSubviews(dateLabel, nicknameLabel)
            
        contentView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(self.contentLayoutGuide)
            $0.width.equalToSuperview()
        }
            
        correnctionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(20)
        }
            
        switch viewType {
        case .correction:
            contentView.snp.makeConstraints {
                $0.height.equalTo(correctiontextViewTotalHeight)
            }
                
            contentTextView.snp.makeConstraints {
                $0.top.equalTo(correnctionLabel.snp.bottom).offset(6)
                $0.leading.trailing.equalToSuperview().inset(18)
            }
                
        case .correctionHasRandomSubject:
            // 랜덤 주제 추가된 레이아웃으로 수정
            contentView.snp.makeConstraints {
                $0.height.equalTo(correctiontextViewTotalHeight)
            }
        case .detailDiary:
            correnctionLabel.isHidden = true
                
            contentView.snp.makeConstraints {
                $0.height.equalTo(detailDiaryTotalContentViewHeight)
            }
                
            contentTextView.snp.makeConstraints {
                $0.top.equalToSuperview().inset(16)
                $0.leading.trailing.equalToSuperview().inset(18)
            }
                
        case .detailDiaryHasRandomSubject:
            correnctionLabel.isHidden = true
                
            // 랜덤 주제 추가된 레이아웃으로 수정
            contentView.snp.makeConstraints {
                $0.height.equalTo(detailDiaryTotalContentViewHeight)
            }
        }
            
        labelStackView.snp.makeConstraints {
            $0.top.equalTo(contentTextView.snp.bottom).offset(24)
            $0.trailing.equalToSuperview().inset(18)
        }
    }
}

// MARK: - UITextViewDelegate

extension DiaryScrollerView: UITextViewDelegate {
    func textView(_ textView: UITextView,
                  editMenuForTextIn range: NSRange,
                  suggestedActions: [UIMenuElement]) -> UIMenu? {
        var additionalActions: [UIMenuElement] = []
        
        if range.length > 0 {
            let chanmiAction = UIAction(title: "첨삭") {_ in
                print(textView.text(in: textView.selectedTextRange ?? UITextRange()) ?? String())
            }
            additionalActions.append(chanmiAction)
        }
        return UIMenu(children: additionalActions)
    }
}
