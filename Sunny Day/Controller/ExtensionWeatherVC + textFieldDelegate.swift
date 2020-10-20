//
//  ExtensionWeatherVC + textFieldDelegate.swift
//  Sunny Day
//
//  Created by Heiner Bruß on 16.09.20.
//  Copyright © 2020 Heiner Bruß. All rights reserved.
//

import UIKit

extension WeatherViewController: UITextFieldDelegate {
    
    //MARK:- TextField Delegate Methode
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            return true
        } else {
            textField.placeholder = "Please enter a city name"
            return false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            activity(animating: true)
            NetworkManager.shared.fetchWeatherWithCityName(cityName: city, completion: handleWeatherFetch(model:error:))
            activity(animating: false)
        }
        searchTextField.text = ""
    }
}
