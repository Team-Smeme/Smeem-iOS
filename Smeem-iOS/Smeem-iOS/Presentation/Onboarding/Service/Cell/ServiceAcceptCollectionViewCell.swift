//
//  ServiceAcceptCollectionViewCell.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/17.
//

import UIKit

protocol CellProtocol {
    func cellIndexDataSend(indexPath: Int)
}

final class ServiceAcceptCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ServiceAcceptCollectionViewCell"
    
    var cellProtocol: CellProtocol?
    
    // MARK: - UI Property
    
    private lazy var checkButton: UIImageView = {
        let button = UIImageView()
        button.image = Constant.Image.icnCheckInactive
        return button
    }()
    
    private let serviceAcceptLabel: UILabel = {
        let label = UILabel()
        label.font = .b4
        label.setTextWithLineHeight(lineHeight: 22)
        label.textColor = .gray600
        return label
    }()
    
    private lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setImage(Constant.Image.icnForward, for: .normal)
        button.addTarget(self, action: #selector(moreButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - @objc
    
    @objc func moreButtonDidTap() {
        cellProtocol?.cellIndexDataSend(indexPath: getIndexPath()!.item)
    }
    
    // MARK: - Custom Method
    
    func setData(_ text: String) {
        serviceAcceptLabel.text = text
    }
    
    func selectedCell() {
        serviceAcceptLabel.textColor = .black
        checkButton.image = Constant.Image.icnCheckActive
    }
    
    func deselectedCell() {
        serviceAcceptLabel.textColor = .gray600
        checkButton.image = Constant.Image.icnCheckInactive
    }
    
    // MARK: - Layout
    
    private func setLayout() {
        addSubviews(checkButton, serviceAcceptLabel, moreButton)
        
        checkButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        serviceAcceptLabel.snp.makeConstraints {
            $0.leading.equalTo(checkButton.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
        }
        
        moreButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(55)
        }
    }
}
