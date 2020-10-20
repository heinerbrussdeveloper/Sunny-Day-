//
//  ExtensionWeatherVC + location.swift
//  Sunny Day
//
//  Created by Heiner Bruß on 16.09.20.
//  Copyright © 2020 Heiner Bruß. All rights reserved.
//

import UIKit
import CoreLocation


extension WeatherViewController: CLLocationManagerDelegate {
    
 //MARK:- Location Manager Methods
    
     func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
    }
    
     func getCurrentLocation() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            NetworkManager.shared.fetchWeatherWithCoordinates(latitude: lat, longitude: lon, completion: handleWeatherFetch(model:error:))
            activity(animating: false)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
