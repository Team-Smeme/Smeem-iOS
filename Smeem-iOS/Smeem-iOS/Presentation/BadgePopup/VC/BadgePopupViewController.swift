//
//  BadgePopupViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/06/29.
//

import UIKit
import StoreKit
import Combine

import SnapKit

enum BadgeButtonType {
    case cancel
    case more
}

final class BadgePopupViewController: UIViewController, SKStoreProductViewControllerDelegate {
    
    private let viewModel = BadgePopupViewModel()
    let summarySubject = PassthroughSubject<Void, Never>()
    let firstDiarySubject = PassthroughSubject<Void, Never>()
    
    // MARK: Publisher
    
    private let viewWillAppearSubject = PassthroughSubject<Void, Never>()
    private let amplitudeSujbect = PassthroughSubject<BadgeButtonType, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    // MARK: UI Properties
    
    private let popupView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.makeRoundCorner(cornerRadius: 10)
        view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        return view
    }()
    
    private let badgeImage: UIImageView = {
        let image = UIImageView()
        image.image = Constant.Image.colorWelcomeBadge
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let badgeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .s3
        label.textColor = .black
        label.text = "웰컴 배지"
        return label
    }()
    
    private let badgeDetailLabel: UILabel = {
        let label = UILabel()
        label.font = .c3
        label.textColor = .gray600
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = """
                     축하해요!
                     웰컴 배지를 획득했어요!
                     """
        return label
    }()
    
    private lazy var cancleButton: SmeemButton = {
        let button = SmeemButton(buttonType: .enabled, text: "닫기")
        button.backgroundColor = .gray100
        button.titleLabel?.font = .c2
        button.setTitleColor(.gray600, for: .normal)
        return button
    }()
    
    private let presentBadgeListButton: SmeemButton = {
        let button = SmeemButton(buttonType: .enabled, text: "배지 모두보기")
        button.titleLabel?.font = .c2
        return button
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        setLayout()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewWillAppearSubject.send(())
    }
    
    init(popupBadge: [PopupBadge]) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel.popupBadge = popupBadge
        
        if popupBadge[0].type == "EVENT" {
            presentBadgeListButton.setTitle("첫 일기 쓰러가기", for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Method
    
    private func bind() {
        cancleButton.tapPublisher
            .sink { [weak self] _ in
                self?.amplitudeSujbect.send(.cancel)
            }
            .store(in: &cancelBag)
        
        presentBadgeListButton.tapPublisher
            .sink { [weak self] _ in
                self?.amplitudeSujbect.send(.more)
            }
            .store(in: &cancelBag)
        
        let input = BadgePopupViewModel.Input(viewWillAppearSubject: viewWillAppearSubject,
                                              amplitudeSujbect: amplitudeSujbect)
        let output = viewModel.transform(input: input)
        
        output.viewWillAppearResult
            .sink { [weak self] popupBadge in
                for popup in popupBadge {
                    let url = URL(string: popup.imageUrl)
                    self?.badgeImage.kf.setImage(with: url)
                    self?.badgeTitleLabel.text = popup.name
                    self?.badgeDetailLabel.text = """
                                                축하해요!
                                                \(popup.name)를 획득했어요!
                                                """
                }
            }
            .store(in: &cancelBag)
        
        output.cancelButtonResult
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &cancelBag)
        
        output.moreBadgeListResult
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
                self?.summarySubject.send(())
            }
            .store(in: &cancelBag)
        
        output.firstDiaryResult
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
                self?.firstDiarySubject.send(())
            }
            .store(in: &cancelBag)
        
        output.reviewPopupResult
            .sink { _ in
                if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                    DispatchQueue.main.async {
                        SKStoreReviewController.requestReview(in: scene)
                    }
                }
            }
            .store(in: &cancelBag)
    }
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true)
    }
}

// MARK: - Layout

extension BadgePopupViewController {
    private func setBackgroundColor() {
        view.backgroundColor = .popupBackground
    }
    
    private func setLayout() {
        view.addSubview(popupView)
        popupView.addSubviews(badgeImage, badgeTitleLabel, badgeDetailLabel, cancleButton, presentBadgeListButton)
        
        popupView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(convertByHeightRatio(201))
            $0.centerX.equalToSuperview()
            $0.width.equalTo(convertByWidthRatio(298))
            $0.height.equalTo(convertByHeightRatio(390))
        }
        
        badgeImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(convertByHeightRatio(28))
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(convertByHeightRatio(164))
        }
        
        badgeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(badgeImage.snp.bottom).offset(convertByHeightRatio(12))
            $0.centerX.equalToSuperview()
        }
        
        badgeDetailLabel.snp.makeConstraints {
            $0.top.equalTo(badgeTitleLabel.snp.bottom).offset(convertByHeightRatio(33))
            $0.centerX.equalToSuperview()
        }
        
        cancleButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(convertByHeightRatio(10))
            $0.trailing.equalTo(presentBadgeListButton.snp.leading).offset(convertByHeightRatio(-8))
            $0.bottom.equalToSuperview().inset(convertByHeightRatio(10))
            $0.width.equalTo(convertByWidthRatio(135))
            $0.height.equalTo(convertByHeightRatio(50))
        }
        
        presentBadgeListButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(convertByHeightRatio(10))
            $0.bottom.equalToSuperview().inset(convertByHeightRatio(10))
            $0.height.equalTo(convertByHeightRatio(50))
        }
    }
}
