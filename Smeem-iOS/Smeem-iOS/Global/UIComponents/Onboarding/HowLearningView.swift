//
//  HowLearningView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/16.
//

/**
 1. 사용할 VC에서 호출
private let howLearningView: HowLearningView = {
 let view = HowLearningView()
 return view
 }()
 
 2. 자신이 사용할 UI에 맞는 ButtonType 설정 후 사용 (ButtonType은 logo, edit 두 개)
 private let howLearningView: HowLearningView = {
  let view = HowLearningView()
  view.buttonType = .edit
  return view
  }()
 
 3. view 자체의 넓이와 높이값 줄 필요 없이  VC에서는 레이아웃만 잡아 주면 됨
 ex) 예시임
 howLearningView.snp.makeConstraints {
     $0.top.equalTo(learningLabelStackView.snp.bottom).offset(28)
     $0.centerX.equalToSuperview()
 }
 */

import UIKit

final class HowLearningView: UIView {
    
    // MARK: - ButtonType
    
    enum ButtonType {
        case logo
        case edit
    }
    
    // MARK: - Property
    
    var buttontype: ButtonType = .logo {
        didSet {
            showButtonType()
        }
    }
    
    // MARK: - UI Property
    
    private let pointBackgroudView: UIView = {
        let view = UIView()
        view.backgroundColor = .point
        return view
    }()
    
    private let smeemLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constant.Image.logoWhiteSmeem
        return imageView
    }()
    
    private let editImageView: UIImageView = {
        let image = UIImageView()
        image.image = Constant.Image.icnEditForward
        return image
    }()
    
    private let myGoalLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 목표는"
        label.font = .b3
        label.textColor = .smeemWhite
        return label
    }()
    
    private let selectedMyGoalLabel: UILabel = {
        let label = UILabel()
        label.text = "외국어 업무 문서 읽고 작성하기"
        label.font = .h3
        label.textColor = .smeemWhite
        return label
    }()
    
    private let grayLayerView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    private let learningHowLabel: UILabel = {
        let label = UILabel()
        label.text = "학습 방법"
        label.font = .s2
        label.textColor = .smeemBlack
        return label
    }()
    
    private let firstSelectedLearningHowLabel: UILabel = {
        let label = UILabel()
        label.text = "주 3회 이상 일기 작성히기"
        label.font = .b4
        label.textColor = .gray600
        return label
    }()
    
    private let secondSelectedLearningHowLabel: UILabel = {
        let label = UILabel()
        label.text = "편지글 형태의 일기 작성하기"
        label.font = .b4
        label.textColor = .gray600
        return label
    }()
    
    private let deatilGoalLabel: UILabel = {
        let label = UILabel()
        label.text = "세부 목표"
        label.font = .s2
        label.textColor = .smeemBlack
        return label
    }()
    
    private let firstDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "사전 보지 않고 일기 작성하기"
        label.font = .b4
        label.textColor = .gray600
        return label
    }()
    
    private let secondDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "TOEIC 단어책 뭐뭐하기"
        label.font = .b4
        label.textColor = .gray600
        return label
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Custom Method
    
    private func showButtonType() {
        switch buttontype {
        case .logo:
            editImageView.isHidden = false
        case .edit:
            editImageView.isHidden = false
        }
    }
    
    func setData(planName: String, planWayOne: String, planWayTwo: String, detailPlanOne: String, detailPlanTwo: String) {
        selectedMyGoalLabel.text = planName
        firstSelectedLearningHowLabel.text = planWayOne
        secondSelectedLearningHowLabel.text = planWayTwo
        firstDetailLabel.text = detailPlanOne
        secondDetailLabel.text = detailPlanTwo
    }
    
    // MARK: - Layout
    
    private func setUI() {
        makeRoundCorner(cornerRadius: 10)
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.gray100.cgColor
    }
    
    private func setLayout() {
        let howLearningViewWidth = 327
        let howLearningViewHeight = 370
        let pointBackgroundViewHeight = 129
        
        addSubviews(pointBackgroudView, learningHowLabel, firstSelectedLearningHowLabel, secondSelectedLearningHowLabel,
                    deatilGoalLabel, firstDetailLabel, secondDetailLabel)
        pointBackgroudView.addSubviews(smeemLogo, editImageView, myGoalLabel, selectedMyGoalLabel)
        
        self.snp.makeConstraints {
            $0.width.equalTo(howLearningViewWidth)
            $0.height.equalTo(howLearningViewHeight)
        }
        
        pointBackgroudView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.width.equalTo(howLearningViewWidth)
            $0.height.equalTo(pointBackgroundViewHeight)
        }
        
        smeemLogo.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(22)
            $0.width.equalTo(33)
            $0.height.equalTo(20)
        }
        
        editImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(4)
            $0.width.height.equalTo(40)
        }
        
        myGoalLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(smeemLogo.snp.bottom).offset(23)
        }
        
        selectedMyGoalLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(myGoalLabel.snp.bottom).offset(2)
        }
        
        learningHowLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(pointBackgroudView.snp.bottom).offset(24)
        }
        
        firstSelectedLearningHowLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(learningHowLabel.snp.bottom).offset(12)
        }
        
        secondSelectedLearningHowLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(firstSelectedLearningHowLabel.snp.bottom).offset(6)
        }
        
        deatilGoalLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(secondSelectedLearningHowLabel.snp.bottom).offset(39)
        }
        
        firstDetailLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(deatilGoalLabel.snp.bottom).offset(12)
        }
        
        secondDetailLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(firstDetailLabel.snp.bottom).offset(6)
        }
    }
}
