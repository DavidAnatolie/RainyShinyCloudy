//
//  Forecast.swift
//  RainyShinyCloudy
//
//  Created by David Islam on 2017-08-25.
//  Copyright © 2017 David Islam. All rights reserved.
//

import Foundation
import Alamofire


class Forecast {
    
    private var _day: String!
    private var _type: String!
    private var _high: Double!
    private var _low: Double!
    private var _thumbnail: String!
    
    init(dailyForecast: Dictionary<String, Any>) {
    
        if let temp = dailyForecast["temp"] as? Dictionary<String, Double> {
            
            if let max = temp["max"], let min = temp["min"] {
                self._high = max
                self._low = min
            }
        }
        
        if let weather = dailyForecast["weather"] as? [Dictionary<String, Any>] {
            
            if let description = weather[0]["description"] as? String {
                self._type = description.capitalized
            }
            
            if let main = weather[0]["main"] as? String {
                self._thumbnail = main.capitalized
            }
        }

        if let dt = dailyForecast["dt"] as? Double {
            
            let convertedDate = Date(timeIntervalSince1970: dt) // Unix timestamp
            self._day = convertedDate.getDay() // Remove everything except day of week
        }
    }
    
    var day: String {
        get {
            if _day == nil {
                _day = ""
            }
            return _day
        }
    }
    
    var type: String {
        get {
            if _type == nil {
                _type = ""
            }
            return _type
        }
    }
    
    var high: Double {
        get {
            if _high == nil {
                _high = 0.0
            }
            return _high
        } set {
            _high = newValue
        }
    }
    
    var low: Double {
        get {
            if _low == nil {
                _low = 0.0
            }
            return _low
        } set {
            _low = newValue
        }
    }
    
    var thumbnail: String {
        get {
            if _thumbnail == nil {
                _thumbnail = ""
            }
            return _thumbnail
        }
    }
}

extension Date {
    func getDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE" // For day of week
        return dateFormatter.string(from: self)
    }
}
