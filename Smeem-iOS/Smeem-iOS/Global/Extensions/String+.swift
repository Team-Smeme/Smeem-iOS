//
//  String+.swift
//  Smeem-iOS
//
//  Created by 임주민 on 2023/05/20.
//

import Foundation

extension String {
    
    // 서버에서 가져온 string형 (데이터를 date형으로 변환 후 원하는 형식의 string으로 바꿔준다.
    func getFormattedDate(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" // 서버에서 오는 Date형식
        
        let convertDate = dateFormatter.date(from: self) // String을 Date타입으로 변환
        let myformatter = DateFormatter()
        myformatter.dateFormat = format
        
        let result = myformatter.string(from: convertDate!) // Date를 원하는 형식의 String으로 변환
        
        return result
    }
    
    // string형식의 날짜를 Date형식으로 바꿔준다.
    func stringToDate(format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        guard let convertDate = dateFormatter.date(from: self) else { return Date() }
        
        return convertDate
    }
}
