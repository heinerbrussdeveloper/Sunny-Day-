//
//  ViewController.swift
//  Sunny Day
//
//  Created by Heiner Bruß on 15.09.20.
//  Copyright © 2020 Heiner Bruß. All rights reserved.
//

import UIKit
import CoreLocation

//MARK:- WeatherViewController

class WeatherViewController: UIViewController, FavoritesListViewControllerDelegate {
    //MARK:-Delegate Method
    
    func didSelectCity(city: Favorites) {
        
        self.favoriteName = city.cityName
    }
    
    var favoriteName: String? {
        didSet {
            guard let city = favoriteName else {return}
            activity(animating: true)
            NetworkManager.shared.fetchWeatherWithCityName(cityName: city, completion: handleWeatherFetch(model:error:))
            activity(animating: false)
        }
    }
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Afternoon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.color = .black
        activity.hidesWhenStopped = true
        activity.isHidden = true
        activity.style = .large
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter City Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .words
        return textField
    }()
    
    var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        button.tintColor = .lightYellow
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.imageView?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var geoLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "location.circle"), for: .normal)
        button.tintColor = .lightYellow
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.imageView?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(locationButtonPressed), for: .touchUpInside)
        return button
    }()
    
    var weatherConditionImageView: UIImageView = {
        let weatherImage = UIImageView()
        weatherImage.image = UIImage(systemName: "sun.max")
        weatherImage.translatesAutoresizingMaskIntoConstraints = false
        weatherImage.tintColor = .black
        weatherImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        weatherImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        return weatherImage
    }()
    
    var temperatureLabel: UILabel = {
        let tempLabel = UILabel()
        tempLabel.text = "--°C"
        tempLabel.font = UIFont.boldSystemFont(ofSize: 40)
        tempLabel.textColor = .black
        tempLabel.layer.borderColor =  UIColor.black.cgColor
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        return tempLabel
    }()
    
    var maxTemperatureLabel: UILabel = {
        let tempLabel = UILabel()
        tempLabel.text = "max.Temp --°C"
        tempLabel.textColor = .black
        tempLabel.font = UIFont.boldSystemFont(ofSize: 25)
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        return tempLabel
    }()
    
    var minTemperatureLabel: UILabel = {
        let tempLabel = UILabel()
        tempLabel.text = "min.Temp --°C"
        tempLabel.font = UIFont.boldSystemFont(ofSize: 25)
        tempLabel.textColor = .black
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        return tempLabel
    }()
    
    var cityLabel: UILabel = {
        let cityLabel = UILabel()
        cityLabel.text = "--"
        cityLabel.textColor = .black
        cityLabel.font = UIFont.boldSystemFont(ofSize: 25)
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        return cityLabel
    }()
    
    var locationManager: CLLocationManager! = {
        let locationManager = CLLocationManager()
        return locationManager
    }()
    
    //MARK:- ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupUI()
        searchTextField.delegate = self
        setupLocationManager()
    }
    
    //MARK:- SETUP NAV-Bar
    
    func setupNavBar() {
        navigationItem.title = "Sunny Day"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(favoritesButtonPressed))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .plain, target: self, action: #selector(infoButtonPressed))
    }
    
    //MARK:- Network Request Handler
    
    func handleWeatherFetch(model: WeatherManager?, error: Error?) -> Void {
        DispatchQueue.main.async {
            if  model != nil {
                guard let model = model else {return}
                    self.temperatureLabel.text = "\(model.temperatureString)°C"
                    self.maxTemperatureLabel.text = "max.Temp \(model.maxTemperatureString)°C"
                    self.minTemperatureLabel.text = "min.Temp \(model.minTemperatureString)°C"
                    self.cityLabel.text = model.cityName
                    self.weatherConditionImageView.image = UIImage(systemName: model.conditionName)
                
            } else {
                    self.alert(title: "Error", message: "Please make sure to enter a real city name, and that you are connected to the Internet")
                    print("Handle Fetch Method failed")
            }
        }
    }
    
    //MARK:- Button Methods
    
    @objc func locationButtonPressed() {
        activity(animating: true)
        getCurrentLocation()
    }
    
    @objc func favoritesButtonPressed() {
        let favoritesVC = FavoritesListViewController()
        favoritesVC.delegate = self
        navigationController?.pushViewController(favoritesVC, animated: true)
    }
    
    @objc func searchButtonPressed() {
        if searchTextField.text != "" {
            textFieldDidEndEditing(searchTextField)
        } else {
            alert(title: "No Input", message: "Please insert City")
            return
        }
    }
    
    @objc func infoButtonPressed() {
        alert(title: "How it Works", message: "Please enter a City name into the Seach-Textfield and press enter to search for the current weather. You can also add and delete Favorites and search for your current location")
    }
    
    //MARK:- Setup Activity Indicator Method
    
    func activity(animating: Bool) {
        if animating {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    //MARK:- SETUP UI
    
    
    private func setupUI() {
        view.addSubview(backgroundImageView)
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(activityIndicator)
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        _ = setupOrangeBackgroundView(height: 60)
        view.addSubview(geoLocationButton)
        geoLocationButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        geoLocationButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        geoLocationButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        geoLocationButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        view.addSubview(searchTextField)
        searchTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        searchTextField.leftAnchor.constraint(equalTo: geoLocationButton.rightAnchor, constant: 8).isActive = true
        searchTextField.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        searchTextField.backgroundColor = .newOrange
        
        view.addSubview(searchButton)
        searchButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        searchButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        searchButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        searchButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        view.addSubview(weatherConditionImageView)
        weatherConditionImageView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10).isActive = true
        weatherConditionImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        view.addSubview(temperatureLabel)
        temperatureLabel.topAnchor.constraint(equalTo: weatherConditionImageView.bottomAnchor).isActive = true
        temperatureLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        temperatureLabel.heightAnchor.constraint(equalToConstant: 150).isActive = true
        temperatureLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        view.addSubview(maxTemperatureLabel)
        maxTemperatureLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor).isActive = true
        maxTemperatureLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        view.addSubview(minTemperatureLabel)
        minTemperatureLabel.topAnchor.constraint(equalTo: (maxTemperatureLabel).bottomAnchor, constant: 20).isActive = true
        minTemperatureLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        view.addSubview(cityLabel)
        cityLabel.topAnchor.constraint(equalTo: minTemperatureLabel.bottomAnchor, constant: 20).isActive = true
        cityLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
    }
}

