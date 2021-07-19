//
//  CurrentWeather.swift
//  ForecastAppByJiho
//
//  Created by 김지호 on 2021/07/15.
//

import Foundation

struct CurrentWeather : Codable {
    let dt : Int
    
    struct Weather :Codable {
        let id : Int
        let main : String
        let description : String
        let icon : String
    }
    let weather : [Weather]
    
    struct Main : Codable{
        let temp :Double
        let temp_min : Double
        let temp_max : Double
    }
    let main : Main
    // api.openweathermap.org/data/2.5/weather?q=seoul&appid=fe7e706419ccce4e6dd7ccb39de84427
}
