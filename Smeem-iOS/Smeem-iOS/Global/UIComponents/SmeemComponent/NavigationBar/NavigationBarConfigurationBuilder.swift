//
//  NavigationBarConfigurationBuilder.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/09/11.
//

import UIKit

enum NavigationBarLayout {
    case diaryLayout
    case detailLayout
    case editLayout
    case commentLayout
    case myPageLayout
}

struct NavigationBarConfiguration {
    var leftButtonTitle: String?
    var rightButtonTitle: String?
    var leftButtonImage: UIImage?
    var rightButtonImage: UIImage?
    var title: String?
    var stepLabelTitle: String?
    var layout: NavigationBarLayout?
    
    static func builder() -> NavigationBarConfigurationBuilder {
        return NavigationBarConfigurationBuilder()
    }
}

class NavigationBarConfigurationBuilder {
    private var configuration = NavigationBarConfiguration(
        leftButtonTitle: nil,
        rightButtonTitle: nil,
        leftButtonImage: nil,
        rightButtonImage: nil,
        title: nil,
        stepLabelTitle: nil,
        layout: nil
    )
    
    func withLeftButtonTitle(_ title: String) -> Self {
        configuration.leftButtonTitle = title
        return self
    }
    
    func withRightButtonTitle(_ title: String) -> Self {
        configuration.rightButtonTitle = title
        return self
    }
    
    func withLeftButtonImage(_ image: UIImage?) -> Self {
        configuration.leftButtonImage = image
        return self
    }
    
    func withRightButtonImage(_ image: UIImage?) -> Self {
        configuration.rightButtonImage = image
        return self
    }
    
    func withTitle(_ title: String) -> Self {
        configuration.title = title
        return self
    }
    
    func withStepLabelTitle(_ title: String) -> Self {
        configuration.stepLabelTitle = title
        return self
    }
    
    func withLayout(_ layout: NavigationBarLayout) -> Self {
        configuration.layout = layout
        return self
    }
    
    func build() -> NavigationBarConfiguration {
        return configuration
    }
}
