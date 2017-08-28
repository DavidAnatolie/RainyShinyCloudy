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
    private var _high: String!
    private var _low: String!
    private var _thumbnail: String!
    
    init(dailyForecast: Dictionary<String, Any>) {
    
        if let temp = dailyForecast["temp"] as? Dictionary<String, Double> {
            
            // high
            if let max = temp["max"] {
                self._high = "\(Int(round(max)))"
            }
            
            // low
            if let min = temp["min"] {
                self._low = "\(Int(round(min)))"
            }
        }
        
        if let weather = dailyForecast["weather"] as? [Dictionary<String, Any>] {
            
            // type
            if let description = weather[0]["description"] as? String {
                self._type = description.capitalized
            }
            
            // thumbnail
            if let main = weather[0]["main"] as? String {
                self._thumbnail = main.capitalized
            }
        }
        
        // Day of week
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
    
    var high: String {
        get {
            if _high == nil {
                _high = ""
            }
            return _high
        }
    }
    
    var low: String {
        get {
            if _low == nil {
                _low = ""
            }
            return _low
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
