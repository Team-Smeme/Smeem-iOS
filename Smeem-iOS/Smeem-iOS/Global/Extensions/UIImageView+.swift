//
//  UIImageView+.swift
//  Smeem-iOS
//
//  Created by 황찬미 on 3/27/24.
//

import UIKit

extension UIImageView {
    func loadImage(_ url: String) async throws {
        //        DispatchQueue.global(qos: .background).async {
        let cacheKey = NSString(string: url)
        
        // 1. cache memory에 데이터 있을 때
        if let cacheImage = ImageCacheManager.shared.object(forKey: cacheKey) {
            // 이 작업은 main에서 해 주어야 하지 않나요
            self.image = cacheImage
            print("여기가 되는거야?")
            return
        }
        
        // 2. disk memory 확인
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            throw SmeemError.clientError
        }
        
        var filePath = URL(fileURLWithPath: path)
        filePath.appendPathComponent(url)
        let fileManager = FileManager()
        print("path다", filePath)
        print("저기요?", filePath.path)
        
        if fileManager.fileExists(atPath: filePath.path) {
            print("여긴아예안들어오는거지...")
            guard let url = URL(string: url) else { return }
            
            guard let imageData = try? Data(contentsOf: url) else {
                throw SmeemError.clientError
            }
            
            guard let diskCachedImage = UIImage(data: imageData) else {
                throw SmeemError.clientError
            }
            
            // main.sync여야 하는 이유는?
            //            DispatchQueue.main.sync {
            // disk cache에 있는 데이터를 다시 cache에 추가해 주기
            ImageCacheManager.shared.setObject(diskCachedImage, forKey: cacheKey)
            fileManager.createFile(atPath: filePath.path, contents: imageData)
            self.image = diskCachedImage
            print("여기는 disk")
            //            }
            
            return
        }
        
        // 3. 서버 통신을 통해서 받은 URL로 이미지를 가져온다.
        guard let imageUrl = URL(string: url) else { return }
        let (data, _) = try await URLSession.shared.data(from: imageUrl)
        
        guard let urlImage = UIImage(data: data) else {
            throw SmeemError.clientError
        }
        
        // 새로 받은 데이터 다시 cache에 추가
        ImageCacheManager.shared.setObject(urlImage, forKey: cacheKey)
        fileManager.createFile(atPath: filePath.path, contents: data)
        print("여기는 url입니다")
        self.image = urlImage
        
    }
}
