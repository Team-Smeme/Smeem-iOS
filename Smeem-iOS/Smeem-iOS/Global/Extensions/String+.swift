//
//  String+.swift
//  Smeem-iOS
//
//  Created by Joon Baek on 2023/05/10.
//

import UIKit

extension String {
    
    func getArrayAfterRegex(regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self,
                                        range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    /// 문자열(yyyy-MM-dd HH:mm:ss)을 Date형식으로 바꿔줌
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    
    /// 문자열(HH:mm)을 Date형식으로 바꿔줌
    func toDateFromTime() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    
    /// String -> String 원하는 포맷의 날짜로 변환해줌
    func formatted(_ format: String) -> String {
        guard let date = self.toDateFromTime() else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        formatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)!
        return formatter.string(from: date)
    }
}
