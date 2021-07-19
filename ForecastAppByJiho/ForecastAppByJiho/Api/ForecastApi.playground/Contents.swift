import UIKit

import CoreLocation

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

enum ApiError : Error {
    case unknown
    case invalidUrl(String)
    case invalidResponse
    case failed(Int)
    case emptyData
}

// 어느 디코딩이든 가능 하게 만들기
func fetch<ParsingType: Codable>(urlStr : String , completion : @escaping (Result<ParsingType, Error>) -> ()) {
    // URL 인스턴스 생성
    guard let url = URL(string : urlStr) else {
//        fatalError("URL 생성 실패")
        completion(.failure(ApiError.invalidUrl(urlStr)))
        return
    }
    // URLSession에 task 주기
    let task = URLSession.shared.dataTask(with: url) {
        (data , respone , error) in
        if let error = error { // 에러가 있다면
//            fatalError(error.localizedDescription)
            completion(.failure(error))
            return
            
        }
        // respone이 존재하지 않다면 에러표시
        guard let httpResponse = respone as? HTTPURLResponse else {
            completion(.failure(ApiError.invalidResponse))
            return
            
        }
        // 상태코드가 200번이 아니라면 에러 표시
        guard httpResponse.statusCode == 200  else {
            completion(.failure(ApiError.failed(httpResponse.statusCode)))
            return
        }
        //data 가 없다면
        guard let data = data else {
//            fatalError("empty data")
            completion(.failure(ApiError.emptyData))
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
            completion(.failure(error))
        }
        
    }
    task.resume()
}

func fetchForecast(cityName : String , completion : @escaping (Result< Forecast , Error>) -> ()) {
    let urlStr = "https://api.openweathermap.org/data/2.5/forecast?q=\(cityName)&appid=fe7e706419ccce4e6dd7ccb39de84427&units=metric&lang=kr"
    
    fetch(urlStr: urlStr, completion: completion)
}
func fetchForecast(cityId : Int , completion : @escaping (Result< Forecast , Error>) -> ()) {
    let urlStr = "https://api.openweathermap.org/data/2.5/forecast?id=\(cityId)&appid=fe7e706419ccce4e6dd7ccb39de84427&units=metric&lang=kr"
    
    fetch(urlStr: urlStr, completion: completion)
}
func fetchForecast(location : CLLocation , completion : @escaping (Result< Forecast , Error>) -> ()) {
    let urlStr = "https://api.openweathermap.org/data/2.5/forecast?&appid=fe7e706419ccce4e6dd7ccb39de84427&units=metric&lang=kr"
    
    fetch(urlStr: urlStr, completion: completion)
}

fetchForecast(cityName: "seoul") { _ in
    return
}

fetchForecast(cityId: 1835847) { result in
    switch result {
    case .success(let data):
        dump(data)
    case .failure(let error):
        print(error.localizedDescription)
    }
}


