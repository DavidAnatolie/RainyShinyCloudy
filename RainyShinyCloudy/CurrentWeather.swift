//
//  CurrentWeather.swift
//  RainyShinyCloudy
//
//  Created by David Islam on 2017-08-24.
//  Copyright © 2017 David Islam. All rights reserved.
//

import Foundation
import Alamofire


class CurrentWeather {
    private var _date: String!
    private var _currentTemp: Double!
    private var _cityName: String!
    private var _weatherType: String!
    private var _weatherThumbnail: String!
    private var _country: String!
    
    var date: String {
        get {
            if _date == nil {
                _date = ""
            }
            
            // Format the date to 'August 27, 2017'
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            
            let currentDate = dateFormatter.string(from: Date())
            self._date = "Today, \(currentDate)"
            
            return _date
        }
    }
    
    var currentTemp: Double {
        get {
            if _currentTemp == nil {
                _currentTemp = 0.0
            }
            return _currentTemp
        }
    }
    
    var cityName: String {
        get {
            if _cityName == nil {
                _cityName = ""
            }
            return _cityName
        }
    }
    
    var weatherType: String {
        get {
            if _weatherType == nil {
                _weatherType = ""
            }
            return _weatherType
        }
    }
    
    var weatherThumbnail: String {
        get {
            if _weatherThumbnail == nil {
                _weatherThumbnail = ""
            }
            return _weatherThumbnail
        }
    }
    
    var country: String {
        get {
            if _country == nil {
                _country = ""
            }
            return _country
        }
    }
    
    func downloadWeatherDetails(completed: @escaping DownloadComplete) {
        let currentWeatherURL = URL(string: CURRENT_WEATHER_URL)!
        
        // Use Alamofire to extract JSON data
        Alamofire.request(currentWeatherURL).responseJSON {response in
            // Handle the response
            let result = response.result // response serialization result
            
            // serialized json response
            // Remember, type-checking and downcasting
            if let dict = result.value as? Dictionary<String, Any> {
                
                // cityName
                if let name = dict["name"] as? String {
                    self._cityName = name.capitalized
                }
                
                // weatherType and weatherThumbnail
                if let weather = dict["weather"] as? [Dictionary<String, Any>] {
                    
                    if let main = weather[0]["main"] as? String {
                        self._weatherThumbnail = main.capitalized
                    }
                    
                    if let description = weather[0]["description"] as? String {
                        self._weatherType = description.capitalized
                    }
                }
                
                // currentTemp
                if let main = dict["main"] as? Dictionary<String, Double> {
                    
                    if let temp = main["temp"] {
                        self._currentTemp = round(temp)
                    }
                }
                
                // country
                if let sys = dict["sys"] as? Dictionary<String, Any> {
                    
                    if let country = sys["country"] as? String {
                        self._country = country
                    }
                }
            }
            completed() // completion handler
        }
    }
}
