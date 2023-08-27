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
 **/

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
    
    var viewType: ViewType = .detailDiary {
        didSet {
            print("이게 호출이되니?")
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
    
    private lazy var randomSubjectView = DiaryDetailRandomSubjectView()
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .black
        textView.font = .b4
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.text = "I watched Avatar with my boyfriend at Hongdae CGV. I should have skimmed the previous season - Avatar1.. I really couldn’t get what they were saying and the universe(??). What I was annoyed then was 두팔 didn’t know that as me. I think 두팔 who is my boyfriend should study before wathcing…. but Avatar2 is amazing movie I think. In my personal opinion, the jjin main character of Avatar2 is not Sully, but his son. "
        textView.tintColor = .point
//        textView.configureAttributedText()
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
        label.textColor = .gray500
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
    
    func configureDiaryScrollerView(topic: String, contentText: String, date: String, nickname: String) {
        topic != "" ? randomSubjectView.setData(contentText: topic) : print("랜덤주제없음")
        contentTextView.text = contentText
        dateLabel.text = date
        nicknameLabel.text = nickname
        contentTextView.configureAttributedText()
    }
    
    private func calculateTextViewHeight(textView: UITextView) -> CGFloat {
        textView.frame = CGRect(x: 0,
                                y: 0,
                                width: 339,
                                height: .zero)

        let fixedWidth = textView.frame.size.width
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 2.5
        let attributedString = NSAttributedString(string: textView.text, attributes: [.paragraphStyle: style, .font: UIFont.b4])
        let newHeight = attributedString.boundingRect(with: CGSize(width: fixedWidth, height: .zero), options: .usesLineFragmentOrigin, context: nil).height
        textView.attributedText = attributedString
        textView.sizeToFit()
        print("ㄹ아ㅓㅗㄹㅁㅇ", newHeight)

        return ceil(newHeight)
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
        
        // bottomInset 값을 주었는데, 이상하게 적용이 안돼서 78을 또 더해줌... + 일기 수정 후 viewWillAppear에서 TextView 높이 계산 적용 안되는 이슈 해결
        let detailDiaryViewHeight = detailDiaryTopInset+detailbottomInset+calculateTextViewHeight(textView: contentTextView)+78
        // 임의로 한줄일 때의 랜덤주제 높이값 지정 +(2줄기준 84 높이 추가)
        let detailDiaryRandomSubjectViewHeight = detailDiaryTopInset+detailbottomInset+calculateTextViewHeight(textView: contentTextView)+84+78
        let correctiontextViewHeight = correctionTopInset+correctionbottomInset+calculateTextViewHeight(textView: contentTextView)
            
        addSubview(contentView)
        contentView.addSubviews(correnctionLabel, randomSubjectView, contentTextView, labelStackView)
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
                $0.height.equalTo(correctiontextViewHeight)
            }
                
            contentTextView.snp.makeConstraints {
                $0.top.equalTo(correnctionLabel.snp.bottom).offset(6)
                $0.leading.trailing.equalToSuperview().inset(18)
            }
                
        case .correctionHasRandomSubject:
            // 랜덤 주제 추가된 레이아웃으로 수정
            contentView.snp.makeConstraints {
                $0.height.equalTo(correctiontextViewHeight)
            }
            
        case .detailDiary:
            correnctionLabel.isHidden = true
            randomSubjectView.isHidden = true
                
            contentView.snp.makeConstraints {
                $0.height.equalTo(detailDiaryViewHeight)
            }
                
            contentTextView.snp.makeConstraints {
                $0.top.equalToSuperview().inset(8)
                $0.leading.trailing.equalToSuperview().inset(18)
            }
                
        case .detailDiaryHasRandomSubject:
            correnctionLabel.isHidden = true
                
            // 랜덤 주제 추가된 레이아웃으로 수정
            contentView.snp.makeConstraints {
                $0.height.equalTo(detailDiaryRandomSubjectViewHeight)
            }
            
            randomSubjectView.snp.makeConstraints {
                $0.top.leading.equalToSuperview()
            }
            
            contentTextView.snp.makeConstraints {
                // 텍스트뷰와의 간격을 위해 임의의 값 지정
                $0.top.equalTo(randomSubjectView.snp.bottom).offset(5)
                $0.leading.trailing.equalToSuperview().inset(18)
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
