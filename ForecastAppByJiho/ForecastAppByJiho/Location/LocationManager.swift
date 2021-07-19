//
//  LocationManager.swift
//  ForecastAppByJiho
//
//  Created by 김지호 on 2021/07/19.
//

import Foundation
import CoreLocation

class LocationManager : NSObject {
    
    static let shared = LocationManager()
    private override init(){
        manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers // 로케이션 정확도 추가
    
        super.init()
        
        manager.delegate = self
    }
    
    let manager : CLLocationManager
    
    var currentLocationTitle : String? {
        didSet {
            var userInfo = [AnyHashable : Any]()
            if let location = currentLocation {
                userInfo["location"] = location
            }
            NotificationCenter.default.post(name: Self.currentLocationDidUpdate, object: nil, userInfo: userInfo)
        }
    }
    var currentLocation : CLLocation?
    
    static let currentLocationDidUpdate = Notification.Name("currentLocationDidUpdate")
    
    func updateLocation() {
        let status : CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            status = manager.authorizationStatus
        } else {
            // Fallback on earlier versions
            status = CLLocationManager.authorizationStatus()
        }
        
        switch status {
        case .notDetermined:
            requestAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            requestCurrentLocation()
        case .denied , .restricted:
            print("not available")
        default:
            print("unknown")
        }
    }
}

extension LocationManager : CLLocationManagerDelegate {
    private func updateAddress(from location: CLLocation){
        // 좌표를 주소로 바꾸기
        let gecoder = CLGeocoder()
        gecoder.reverseGeocodeLocation(location) { [weak self](placemark, error) in
            if let error = error {
                print(error)
                self?.currentLocationTitle = "Unknown"
                return
            }
            
            if let placemark = placemark?.first {
                if let gu = placemark.locality , let dong = placemark.subLocality {
                    self?.currentLocationTitle = "\(gu) \(dong)"
                } else {
                    self?.currentLocationTitle = placemark.name ?? "Unknown"
                }
            }
            
            print(self?.currentLocationTitle)
        }
            
        }
        
    
    private func requestAuthorization()  { // 권한 요청하기
        //Requests the user’s permission to use location services while the app is in use
        manager.requestWhenInUseAuthorization()
    }
    private func requestCurrentLocation() {
        //        manager.startUpdatingLocation()
        manager.requestLocation()
    }
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways , .authorizedWhenInUse:
            requestAuthorization()
        case .notDetermined ,.denied ,.restricted :
            print("not available")
        default:
            print("unknown")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways , .authorizedWhenInUse:
            requestAuthorization()
        case .notDetermined ,.denied ,.restricted :
            print("not available")
        default:
            print("unknown")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print(locations.last)
        if let location = locations.last {
            currentLocation = location
            updateAddress(from: location)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

