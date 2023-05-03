//
//  ColorLiterals.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/05/01.
//

import UIKit

extension UIColor {
    
    static var point: UIColor {
        return UIColor(hex: "#FF6D4C")
    }
    
    static var pointInactive: UIColor {
        return UIColor(hex: "#FFDCD4")
    }
    
    static var smeemWhite: UIColor {
        return UIColor(hex: "#FFFFFF")
    }
    
    static var smeemBlack: UIColor {
        return UIColor(hex: "#171716" )
    }
    
    static var gray100: UIColor {
        return UIColor(hex: "#F5F5F5" )
    }
    
    static var gray200: UIColor {
        return UIColor(hex: "#DEDEDE" )
    }
    
    static var gray300: UIColor {
        return UIColor(hex: "#D2D2D2" )
    }
    
    static var gray400: UIColor {
        return UIColor(hex: "#B8B8B8" )
    }
    
    static var gray500: UIColor {
        return UIColor(hex: "#A6A6A6" )
    }
    
    static var gray600: UIColor {
        return UIColor(hex: "#8C8C8C")
    }
    
    static var toastBackground: UIColor {
        return UIColor(hex: "#474747")
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
    }
}
