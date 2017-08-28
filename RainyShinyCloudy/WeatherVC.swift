//
//  ViewController.swift
//  RainyShinyCloudy
//
//  Created by David Islam on 2017-08-22.
//  Copyright © 2017 David Islam. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation


class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var currentDateLbl: UILabel!
    @IBOutlet weak var currentTempLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherTypeLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var degreesCelsiusBtn: UIButton!
    @IBOutlet weak var degreesFahrenheitBtn: UIButton!
    
    // Location stuff...
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    // Weather stuff...
    var currentWeather = CurrentWeather()
    var tenDayForecast = [Forecast]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        
        // Save the location data
        Location.sharedInstance.lattitude = userLocation.coordinate.latitude
        Location.sharedInstance.longitutde = userLocation.coordinate.longitude
        downloadDataAndUpdateUI()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Hardwire longitude and lattiude coor to Vancouver in case location is denied
        Location.sharedInstance.lattitude = 49.25
        Location.sharedInstance.longitutde = -123.12
        downloadDataAndUpdateUI()
    }
    
    func downloadForecast(completed: @escaping DownloadComplete) {
        
        // Download forecast weather for the table view
        // Use a similar approach to CurrentWeather
        
        Alamofire.request(forecastURL).responseJSON{response in // Closure to capture the response from server
            
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, Any> {
                
                if let list = dict["list"] as? [Dictionary<String, Any>] {
                    
                    for day in list {
                        let forecast = Forecast(dailyForecast: day)
                        self.tenDayForecast.append(forecast)
                    }
                    
                    self.tenDayForecast.removeFirst() // We start from the next day
                    self.tableView.reloadData()
                }
            }
            completed()
        }
    }
    
    func downloadDataAndUpdateUI() {
        currentWeather.downloadWeatherDetails {
            self.downloadForecast {
                self.updateMainUI()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tenDayForecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherCell {
            
            let todaysForecast = tenDayForecast[indexPath.row]
            cell.updateUI(forecast: todaysForecast)
            
            return cell
            
        } else {
            return WeatherCell()
        }
    }
    
    func updateMainUI() {
        currentDateLbl.text = currentWeather.date
        currentTempLbl.text = "\(Int(currentWeather.currentTemp))°"
        locationLbl.text = "\(currentWeather.cityName), \(currentWeather.country)"
        weatherTypeLbl.text = currentWeather.weatherType
        weatherImage.image = UIImage(named: currentWeather.weatherThumbnail)
        
    }
    
    @IBAction func onCelsiusBtnPressed(_ sender: Any) {
        tenDayForecast = [Forecast]()
        degreesFahrenheitBtn.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        degreesCelsiusBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        Location.sharedInstance.units = "metric"
        downloadDataAndUpdateUI()
    }
    
    
    @IBAction func onFahrenheitBtnPressed(_ sender: Any) {
        tenDayForecast = [Forecast]() // Reset array
        degreesCelsiusBtn.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        degreesFahrenheitBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        Location.sharedInstance.units = "imperial"
        downloadDataAndUpdateUI()
    }
}

