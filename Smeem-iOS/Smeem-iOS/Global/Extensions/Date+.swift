//
//  Date+.swift
//  Smeem-iOS
//
//  Created by 임주민 on 2023/06/26.
//

import Foundation

extension Date {

    /// Date를 인자로 들어온 형태의 String으로 바꿔줌 ex) Date().formatted("yyyy-MM-dd HH:mm:ss")
    func toString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)!
        return formatter.string(from: self)
    }
    
    /// 해당 달의 첫일을 리턴
    func startOfMonth() -> Date {
        var components = Calendar.current.dateComponents([.year,.month], from: self)
        components.day = 1
        let firstDateOfMonth: Date = Calendar.current.date(from: components)!
        return firstDateOfMonth
    }
    
    /// 해당 달의 말일을 리턴
    func endOfMonth() -> Date {
        let endDateOfMonth = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth())!
        return endDateOfMonth
    }
    
    /// 날짜에 더하고 빼는 연산 해줌
    func addingDate(addValue: Int) -> String {
        let date = Calendar.current.date(byAdding: .day, value: addValue, to: self)
        return date?.toString("yyyy-MM-dd") ?? ""
    }
}
