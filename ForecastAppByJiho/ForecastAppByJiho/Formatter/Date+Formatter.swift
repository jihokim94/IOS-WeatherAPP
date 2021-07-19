//
//  Date+Formatter.swift
//  ForecastAppByJiho
//
//  Created by 김지호 on 2021/07/19.
//

import Foundation

fileprivate let dateFormatter : DateFormatter = {
    let f = DateFormatter()
    f.locale = Locale(identifier: "ko_kr")
    return f
}()

extension Date{
    var dateString : String {
        dateFormatter.dateFormat = "M월 d일"
        return dateFormatter.string(from: self)
    }
    
    var timeString : String {
        dateFormatter.dateFormat = "HH:00"
        return dateFormatter.string(from: self)
    }
}
