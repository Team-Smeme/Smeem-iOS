//
//  BottomSheetViewController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/05/06.
//

import UIKit

import SnapKit

final class BottomSheetViewController: UIViewController {
    
    // MARK: - Property
    
    // MARK: - UI Property
    
    private lazy var bottomSheetView: BottomSheetView = {
        let view = BottomSheetView()
        view.backgroundColor = .brown
        view.viewType = .login
        return view
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - @objc
    
    // MARK: - Custom Method
    
    private func setLayout() {
        view.addSubview(bottomSheetView)
        
        bottomSheetView.snp.makeConstraints {
            $0.height.equalTo(282)
            $0.leading.trailing.equalToSuperview()
            $0.centerX.centerY.equalToSuperview()
        }
    }

}
