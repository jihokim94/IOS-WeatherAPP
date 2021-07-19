//
//  ViewController.swift
//  ForecastAppByJiho
//
//  Created by 김지호 on 2021/07/12.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    
    var topInset = CGFloat(0.0)
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 테이블뷰 마진탑 주기
        if topInset == 0.0 {
            let firstIndexPath = IndexPath(row: 0, section: 0)
            if let cell = listTableView.cellForRow(at: firstIndexPath){ // 첫번째 셀 가져오기
                topInset = listTableView.frame.height - cell.frame.height
                
                var inset = listTableView.contentInset
                inset.top = topInset
                listTableView.contentInset = inset
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTableView.backgroundColor = .clear
        listTableView.separatorStyle = .none
        listTableView.showsVerticalScrollIndicator = false
        
//        let location  = CLLocation(latitude:37.498095, longitude:127.02861)
//        WeatherDataSource.shared.fetch(location: location) {
//            self.listTableView.reloadData()
//            dump(WeatherDataSource.shared.summary?.weather)
//        }
        
        LocationManager.shared.updateLocation()
        
        NotificationCenter.default.addObserver(forName: WeatherDataSource.weatherInfoDidUpdate, object: nil, queue: .main) { (noti) in
            self.listTableView.reloadData()
            self.locationLabel.text = LocationManager.shared.currentLocationTitle
        }
        
    }


}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // 섹션당 들어가야할 로우 개수 리턴
        switch section {
        case 0:
            return 1
        case 1:
            return WeatherDataSource.shared.forecastList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //데이터 섹션에 집어 넣기
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryTableViewCell", for: indexPath) as! SummaryTableViewCell
            if let weather =  WeatherDataSource.shared.summary?.weather.first , let main = WeatherDataSource.shared.summary?.main {
                cell.weatherImageView.image = UIImage(named: weather.icon)
                print(weather.icon)
                
                cell.statusLabel.text = weather.description
                print(weather.description)
                cell.minMaxLabel.text = "최고\(main.temp_min.temperatureString)  최저\(main.temp_max.temperatureString)"
                cell.currentTemperatureLabel.text = main.temp.temperatureString
            }

            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastTableViewCell", for: indexPath) as! ForecastTableViewCell
        
        let target = WeatherDataSource.shared.forecastList[indexPath.row]
        cell.dateLabel.text  = target.date.dateString
        cell.timeLabel.text  = target.date.timeString
        cell.weatherImageView.image = UIImage(named: target.icon)
        cell.statusLabel.text = target.weather.description
        cell.temperaturelabel.text = target.temperature.temperatureString
            return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // 섹션 개수
    }
    
    
}
