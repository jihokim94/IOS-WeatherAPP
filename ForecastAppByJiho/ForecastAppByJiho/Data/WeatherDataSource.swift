//
//  WeatherDataSource.swift
//  ForecastAppByJiho
//
//  Created by 김지호 on 2021/07/15.
//

import Foundation
import CoreLocation

class WeatherDataSource {
    static let shared = WeatherDataSource()
    private init(){
        
    }
    
    var summary : CurrentWeather?
    var forecastList = [ForecastData]()
    
    let apiQueue = DispatchQueue(label: "ApiQueue" , attributes: [.concurrent])
    
    let group = DispatchGroup()
    
    func fetch(location : CLLocation , completion : @escaping () -> ()) {
        //두개 이상의 그룹을 하나의 논리 구성하고 싶다면 enter와 leave짝을 맞춰줘야한다
        group.enter()
        apiQueue.async {
            self.fetchCurrentWeather(location: location) { (result) in
                switch result {
                case .success(let data) :
                    self.summary = data
                default :
                    self.summary = nil
                }
                self.group.leave()
            }
        }
        group.enter()
        apiQueue.async {
            self.fetchForecast(location: location) { (result) in
                switch result {
                case .success(let data) :
                    self.forecastList = data.list.map{
                        //json 값을 Date로 바꾸는법
                        let dt = Date(timeIntervalSince1970: TimeInterval($0.dt))
                        
                        let icon = $0.weather.first?.icon ?? ""
                        let weather = $0.weather.first?.description ?? "알 수 없음"
                        let temperature = $0.main.temp
                        
                        return ForecastData(date: dt, icon: icon, weather: weather, temperature: temperature)
                    }
                default :
                    self.forecastList = []
                }
                self.group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
}

extension WeatherDataSource {
    private func fetch<ParsingType: Codable>(urlStr : String , completion : @escaping (Result<ParsingType, Error>) -> ()) {
        // URL 인스턴스 생성
        guard let url = URL(string : urlStr) else {
            //        fatalError("URL 생성 실패")
            completion(.failure(ApiError.invalidUrl(urlStr)))
            print("invalidUrl")
            return
        }
        // URLSession에 task 주기
        let task = URLSession.shared.dataTask(with: url) {
            (data , respone , error) in
            if let error = error { // 에러가 있다면
                //            fatalError(error.localizedDescription)
                completion(.failure(error))
                print("error")
                return
                
            }
            // respone이 존재하지 않다면 에러표시
            guard let httpResponse = respone as? HTTPURLResponse else {
                completion(.failure(ApiError.invalidResponse))
                print("invalidResponse")
                return
                
            }
            // 상태코드가 200번이 아니라면 에러 표시
            guard httpResponse.statusCode == 200  else {
                completion(.failure(ApiError.failed(httpResponse.statusCode)))
                print("statusCode")
                return
            }
            //data 가 없다면
            guard let data = data else {
                //            fatalError("empty data")
                completion(.failure(ApiError.emptyData))
                print("emptyData")
                return
            }
            do {
                // json data 디코드 하기
                let decoder = JSONDecoder()
                let data = try decoder.decode(ParsingType.self, from: data)
                
                completion(.success(data))
            } catch {
                //            print(error)
                //            fatalError(error.localizedDescription)
                print(error.localizedDescription)
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
    
    // WeatherFetch
    
    private func fetchCurrentWeather(cityName : String , completion : @escaping (Result< CurrentWeather , Error>) -> ()) {
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(apiKey)&units=metric&lang=kr"
        
        fetch(urlStr: urlStr, completion: completion)
    }
    private func fetchCurrentWeather(cityId : Int , completion : @escaping (Result< CurrentWeather , Error>) -> ()) {
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?id=\(cityId)&appid=\(apiKey)&units=metric&lang=kr"
        
        fetch(urlStr: urlStr, completion: completion)
    }
    private func fetchCurrentWeather(location : CLLocation , completion : @escaping (Result< CurrentWeather , Error>) -> ()) {
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?&lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(apiKey)&units=metric&lang=kr"
        
        print(urlStr)
        fetch(urlStr: urlStr, completion: completion)
    }
    
    // ForecastFetch
    
    private func fetchForecast(cityName : String , completion : @escaping (Result< Forecast , Error>) -> ()) {
        let urlStr = "https://api.openweathermap.org/data/2.5/forecast?q=\(cityName)&appid=\(apiKey)&units=metric&lang=kr"
        
        fetch(urlStr: urlStr, completion: completion)
    }
    private func fetchForecast(cityId : Int , completion : @escaping (Result< Forecast , Error>) -> ()) {
        let urlStr = "https://api.openweathermap.org/data/2.5/forecast?id=\(cityId)&appid=\(apiKey)&units=metric&lang=kr"
        
        fetch(urlStr: urlStr, completion: completion)
    }
    private func fetchForecast(location : CLLocation , completion : @escaping (Result< Forecast , Error>) -> ()) {
        let urlStr = "https://api.openweathermap.org/data/2.5/forecast?&lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(apiKey)&units=metric&lang=kr"
        print(urlStr)
        fetch(urlStr: urlStr, completion: completion)
    }
    
    
} // extension
