//
//  NetworkManager.swift
//  Sunny Day
//
//  Created by Heiner Bruß on 15.09.20.
//  Copyright © 2020 Heiner Bruß. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

//MARK:- Network Manager

class NetworkManager {
    
    static let shared = NetworkManager()
    
    
    let apiKey = "e111dadf4681448ce7a26c7caa683226"
    let baseUrl = "https://api.openweathermap.org/data/2.5/weather"
    
    //MARK:- GET Weather with City Name
    
    func fetchWeatherWithCityName(cityName: String, completion: @escaping (WeatherManager?, Error?) -> Void) {
        let urlString: String = "\(baseUrl)?appid=\(apiKey)&units=metric&q=\(cityName)"
        
        if let url = URL(string: urlString)  {
            
            print(url)
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let downloadError = error {
                    completion(nil, downloadError)
                }
                guard let data = data else {return}
                
                do {
                    let responseObject = try JSONDecoder().decode(WeatherData.self, from: data)
                    print(responseObject)
                    
                    let weather = self.parseResponseObject(responseObject)
                    completion(weather, nil)
                } catch let error{
                    completion(nil, error)
                }
            }
            task.resume()
        }
    }
    
    //MARK:- Get Weather with Latitude and Longitude
    
    func fetchWeatherWithCoordinates(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (WeatherManager?, Error?) -> Void) {
        let urlString: String = "\(baseUrl)?appid=\(apiKey)&units=metric&lat=\(latitude)&lon=\(longitude)"
        
        if let url = URL(string: urlString)  {
            
            print(url)
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let downloadError = error {
                    completion(nil, downloadError)
                }
                guard let data = data else {return}
                
                do {
                    let responseObject = try JSONDecoder().decode(WeatherData.self, from: data)
                    print(responseObject)
                    
                    let weather = self.parseResponseObject(responseObject)
                    completion(weather, nil)
                } catch let error{
                    completion(nil, error)
                }
            }
            task.resume()
        }
    }
    
    //MARK:- Parse response 
    
    func parseResponseObject(_ object: WeatherData) -> WeatherManager {
        let temp = object.main.temp
        let minTemp = object.main.tempMin
        let maxTemp = object.main.tempMax
        let id = object.weather[0].id
        let name = object.name
        let weather = WeatherManager(cityName: name, temperature: temp, minTemperature: minTemp, maxTemperature: maxTemp, conditionId: id)
        return weather
    }
}


