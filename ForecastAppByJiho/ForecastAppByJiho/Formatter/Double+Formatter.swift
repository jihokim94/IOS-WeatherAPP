//
//  Double+Formatter.swift
//  ForecastAppByJiho
//
//  Created by 김지호 on 2021/07/19.
//

import Foundation
// 외부 접근 불가
fileprivate let temperatureFormatter : MeasurementFormatter = {
    let f = MeasurementFormatter()
    f.locale = Locale(identifier: "ko_kr")
    f.numberFormatter.maximumFractionDigits = 1 // 소수점 한자리 까지
    return f
}() // 클로져로 초기화

extension Double { //더블값을 온도포맷포함 문자열 형태로 형변환 해줌
    var temperatureString : String {
        let temp = Measurement<UnitTemperature>(value: self, unit: .celsius)
        return temperatureFormatter.string(from: temp)
    }
    
}
