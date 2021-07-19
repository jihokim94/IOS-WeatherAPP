import UIKit
import CoreLocation

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

func fetchCurrentWeather(cityName : String , completion : @escaping (Result< CurrentWeather , Error>) -> ()) {
    let urlStr = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=fe7e706419ccce4e6dd7ccb39de84427&units=metric&lang=kr"
    
    fetch(urlStr: urlStr, completion: completion)
}
func fetchCurrentWeather(cityId : Int , completion : @escaping (Result< CurrentWeather , Error>) -> ()) {
    let urlStr = "https://api.openweathermap.org/data/2.5/weather?id=\(cityId)&appid=fe7e706419ccce4e6dd7ccb39de84427&units=metric&lang=kr"
    
    fetch(urlStr: urlStr, completion: completion)
}
func fetchCurrentWeather(location : CLLocation , completion : @escaping (Result< CurrentWeather , Error>) -> ()) {
    let urlStr = "https://api.openweathermap.org/data/2.5/weather?&appid=fe7e706419ccce4e6dd7ccb39de84427&units=metric&lang=kr"
    
    fetch(urlStr: urlStr, completion: completion)
}

fetchCurrentWeather(cityName: "seoul") { _ in
    return
}

fetchCurrentWeather(cityId: 1835847) { result in
    switch result {
    case .success(let data):
        dump(data)
    case .failure(let error):
        print(error.localizedDescription)
    }
}


