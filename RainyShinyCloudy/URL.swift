//
//  Constants.swift
//  RainyShinyCloudy
//
//  Created by David Islam on 2017-08-24.
//  Copyright © 2017 David Islam. All rights reserved.
//

import Foundation


let LATTITUDE = Location.sharedInstance.lattitude!
let LONGITUDE = Location.sharedInstance.longitutde!
var units = Location.sharedInstance.units

var currentWeatherURL = "http://api.openweathermap.org/data/2.5/weather?lat=\(LATTITUDE)&lon=\(LONGITUDE)&appid=b91632ecd31c8caf986e6c39ba5941dd&units=\(units)/get"

var forecastURL = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(LATTITUDE)&lon=\(LONGITUDE)&cnt=10&appid=b91632ecd31c8caf986e6c39ba5941dd&units=\(units)/get"

typealias DownloadComplete = () -> ()
