//
//  Forecast.swift
//  ForecastAppByJiho
//
//  Created by 김지호 on 2021/07/15.
//

import Foundation

struct Forecast : Codable {
    let cod : String
    let message : Int
    let cnt : Int
    
    struct ListItem : Codable {
        let dt : Int
        struct Main : Codable {
            let temp : Double
        }
        let main : Main
        
        struct Weather : Codable{
            let description : String
            let icon : String
        }
        
        let weather : [Weather]
    }
    
    let list : [ListItem]
    
}

struct ForecastData { // 테이블에 잘 넣을 수 있도록 구조체 하나 더만듬
    let date : Date
    let icon : String
    let weather : String
    let temperature : Double
}
