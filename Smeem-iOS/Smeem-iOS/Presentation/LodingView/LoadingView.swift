//
//  LodingView.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 2023/07/05.
//

import UIKit

final class LoadingView: UIView {
    
    var isLoading = false {
        didSet {
            self.isHidden = !self.isLoading
            self.isLoading ? self.indicatorView.startAnimating() :
                            self.indicatorView.stopAnimating()
        }
    }
    
    let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        return indicatorView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setBackgroundColor()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setBackgroundColor() {
        backgroundColor = .popupBackground
    }
    
    private func setLayout() {
        addSubview(indicatorView)
        
        indicatorView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
