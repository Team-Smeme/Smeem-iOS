//
//  ImageCacheManager.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 3/27/24.
//

import UIKit

final class ImageCacheManager {
    // KeyType, ObjectType 모두 Class
    static let shared = NSCache<NSString, UIImage>()
    private init() {}
}
