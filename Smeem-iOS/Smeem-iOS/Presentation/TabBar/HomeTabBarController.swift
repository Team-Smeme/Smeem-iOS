//
//  HomeTabBarController.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 8/3/25.
//

import UIKit
import SwiftUI

class HomeTabBarController: UITabBarController {
    
    let homeVC = HomeViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray400
        UITabBar.appearance().tintColor = UIColor.black
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(named: "icnCalendarTabBarMono"),
            selectedImage: UIImage(named: "icnCalendarTabBar")
        )
        
        
        let secondSwiftUIView = BookmarkView()
        let secondVC = UIHostingController(rootView: secondSwiftUIView)
        secondVC.tabBarItem = UITabBarItem(
            title: "북마크",
            image: UIImage(named: "icnBookmarkTabBarMono"),
            selectedImage: UIImage(named: "icnBookmarkTabBar")
        )
        
        viewControllers = [homeNav, secondVC]
    }
}
