//  ChangeCityViewController.swift
//  PPWeatherCheck
//  Created by Jerry Tan on 10/2/2019.
//  Copyright (c) 2019 Horus Falcon Tech. All rights reserved.

import UIKit


//Write the protocol declaration.
protocol ChangeCityDelegate {
    func userEnteredANewCityName(city: String)
}




class ChangeCityViewController: UIViewController {
    
    //Declare the delegate variable.
    var delegate : ChangeCityDelegate?
    

    
    //This is the pre-linked IBOutlets to the text field.
    @IBOutlet weak var changeCityTextField: UITextField!

    
    //This is the IBAction that gets called when the user taps on the Check tWeather button.
    @IBAction func getWeatherPressed(_ sender: UIButton) {
        
        //Get the city name the user entered in the text field.
        let cityName = changeCityTextField.text!
        
        // If we have a delegate set, call the method userEnteredANewCityName.
        delegate?.userEnteredANewCityName(city: cityName)
        
        
        // dismiss the Change City View Controller to go back to the WeatherViewController.
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    

    //This is the IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
