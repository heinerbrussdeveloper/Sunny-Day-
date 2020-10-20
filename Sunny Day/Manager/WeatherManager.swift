//
//  WeatherManager.swift
//  Sunny Day
//
//  Created by Heiner Bruß on 15.09.20.
//  Copyright © 2020 Heiner Bruß. All rights reserved.
//

import Foundation

struct WeatherManager {
    
    //MARK:-Weather Manager
    
    
    let cityName: String
    let temperature: Double
    let minTemperature: Double
    let maxTemperature: Double
    let conditionId: Int
    
    var conditionName: String {
        switch conditionId {
        case 200:
            return "cloud.bolt"
        case 201...232:
            return "cloud.bolt.rain"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
    var temperatureString: String {
        return String(format: "%.1f", temperature) 
    }
    
    var minTemperatureString: String {
        return String(format: "%.1f", minTemperature)
    }
    
    var maxTemperatureString: String {
        return String(format: "%.1f", maxTemperature)
    }
}
