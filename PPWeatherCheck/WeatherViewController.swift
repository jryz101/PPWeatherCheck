//  WeatherViewController.swift
//  PPWeatherCheck
//  Created by Jerry Tan on 10/2/2019.
//  Copyright (c) 2019 Horus Falcon Tech. All rights reserved.

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON


class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    //Open Weather Map APIs & Appid.
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "b1ad48076b0a4574df7487110a58ca01"
    
    //Declare object 'locationManager'.
    let locationManager = CLLocationManager()
    //Decalre object 'WeatherDataModel
    let weatherDataModel = WeatherDataModel()
    
    
    //Linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    
    
    
  ///////////////////////////////////////////////////////////////////////////
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    //Set up the locationManager setting here.
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
    //Set up location authorization pop up.
    locationManager.requestWhenInUseAuthorization()
        
    locationManager.startUpdatingLocation()
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        weatherIcon.center.x  -= view.bounds.width
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1.5) {
            self.weatherIcon.center.x += self.view.bounds.width
        }
    }

    ////////////////////////////////////////////////////////////////////////
    
    
    
    
    
    
    
    //MARK: - Networking with Alamofire.
    /***************************************************************/
    //getWeatherData method.
    func getWeatherData (url: String, parameters: [String: String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
          
            response in
            if response.result.isSuccess {
                print("Success! Got The Weather!")
                
            let weatherJSON : JSON = JSON(response.result.value!)
                
            self.updateWeatherData(json: weatherJSON)
                
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
                
            }
        
        }
    
    }
    
    //MARK: - JSON Parsing
    /***************************************************************/
   //Write the updateWeatherData method.
    func updateWeatherData(json : JSON){
        
        if let tempResult = json["main"]["temp"].double {
        
        weatherDataModel.temperature = Int(tempResult - 273.15)
        weatherDataModel.city = json["name"].stringValue
        weatherDataModel.condition = json["weather"][0]["id"].intValue
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
        updateUIWithWeatheData()
        
        }
        else {
    
        cityLabel.text = "Weather Unavailable"
            
        }
    }

    //MARK: - UI Updates
    /***************************************************************/
    //Write the updateUIWithWeatherData method.
    func updateUIWithWeatheData() {
        
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperature)°"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    //didUpdateLocations method.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
        locationManager.stopUpdatingLocation()
            
        locationManager.delegate = nil
            
        print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
         
        // Create openweathermap APIs parameter
        let latitude = String(location.coordinate.latitude)
        let longitude = String(location.coordinate.longitude)
            
        
        let params : [String : String] = ["lat" : latitude,  "lon" : longitude, "appid" : APP_ID]
            
        getWeatherData(url: WEATHER_URL, parameters: params)
            
        }
        
    }
    
    //didFailWithError method here.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unvailable"
    }
    
    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here.
    func userEnteredANewCityName(city: String) {
        
        let params : [String: String] = ["q" : city, "appid" : APP_ID]
        
        getWeatherData(url: WEATHER_URL, parameters: params)
        
    }
    
    //Write the PrepareForSegue Method.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "changeCityName" {
        let destinationVC = segue.destination as! ChangeCityViewController
            
        destinationVC.delegate = self
            
            
            
        }
    }
    
}
    



