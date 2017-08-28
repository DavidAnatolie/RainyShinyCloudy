//
//  Location.swift
//  RainyShinyCloudy
//
//  Created by David Islam on 2017-08-26.
//  Copyright © 2017 David Islam. All rights reserved.
//

import Foundation
import CoreLocation


// 'Singleton' class
class Location {
    public static var sharedInstance = Location()
    private init() {}
    
    var lattitude: Double!
    var longitutde: Double!
}
