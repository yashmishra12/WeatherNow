//
//  ViewController.swift
//  WeatherNow
//
//  Created by Yash Mishra on 5/24/22.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchField.delegate = self
    }
}
    
    //MARK: - UI TextField Delegate
    extension WeatherViewController: UITextFieldDelegate {
        
        @IBAction func searchPressed(_ sender: UIButton) {
            searchField.endEditing(true) //once editing ends --> textFieldDidEndEditing runs
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            if let city = searchField.text {
                weatherManager.fetchWeather(location: city)
            }
            
            searchField.text = ""
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            searchField.endEditing(true)
            return true
        }
        
        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            if textField.text != "" {
                return true
            }
            else {
                textField.placeholder = "Type Something"
                return false
            }
        }
        
    }

    //MARK: - WeatherManager Delegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func updateWeather(_ weather: WeatherModel) {
        DispatchQueue.main.async {
            self.tempLabel.text = weather.temperatureString
            self.weatherImage.image = UIImage(systemName: weather.conditionName)
            self.locationLabel.text = weather.cityName
            let tempDescription = weather.desc
            self.descLabel.text = tempDescription.capitalizeWords()
        }
    }
    
    func failureOccured(error: Error) { print(error) }
}

//MARK: - String Extension
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension String {
    func capitalizeWords() -> String {
        self.split(separator: " ")
        .map({ String($0).capitalizingFirstLetter() })
        .joined(separator: " ")
    }
}

    //MARK: - LocationManager Delegate

extension WeatherViewController: CLLocationManagerDelegate {

    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            weatherManager.fetchWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}




