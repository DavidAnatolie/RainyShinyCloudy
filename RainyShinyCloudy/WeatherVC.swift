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
    @IBOutlet weak var fahrenheitBtn: UIButton!
    @IBOutlet weak var celsiusBtn: UIButton!
    

    let locationManager = CLLocationManager()
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
        locationManager.requestLocation()
        
        celsiusBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        fahrenheitBtn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            let userLocation = locations[0]

            // Save the location data
            Location.sharedInstance.lattitude = userLocation.coordinate.latitude
            Location.sharedInstance.longitutde = userLocation.coordinate.longitude
            currentWeather.downloadWeatherDetails {
                self.downloadForecast {
                    self.updateMainUI()
                }
            }
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Hardwire longitude and lattiude coor to Vancouver in case location is denied
        Location.sharedInstance.lattitude = 49.25
        Location.sharedInstance.longitutde = -123.12
        currentWeather.downloadWeatherDetails {
            self.downloadForecast {
                self.updateMainUI()
            }
        }
    }
    
    func downloadForecast(completed: @escaping DownloadComplete) {
        tenDayForecast = [Forecast]()
        // Download forecast weather for the table view
        // Use a similar approach to CurrentWeather
        Alamofire.request(forecastURL).responseJSON{response in // Closure to capture the response from server
            
            if let dict = response.result.value as? Dictionary<String, Any> {
                
                if let list = dict["list"] as? [Dictionary<String, Any>] {
                    
                    for day in list {
                        self.tenDayForecast.append(Forecast(dailyForecast: day))
                    }
                    
                    self.tenDayForecast.removeFirst() // We start from the next day
                    self.tableView.reloadData()
                }
            }
            completed()
        }
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
        currentTempLbl.text = "\(Int(round(currentWeather.currentTemp)))°"
        locationLbl.text = "\(currentWeather.cityName), \(currentWeather.country)"
        weatherTypeLbl.text = currentWeather.weatherType
        weatherImage.image = UIImage(named: currentWeather.weatherThumbnail)
    }
    
    @IBAction func celsiusBtnPressed(_ sender: Any) {
        if celsiusBtn.currentTitleColor == UIColor.darkGray {
            
            // Update currentTemp
            currentWeather.currentTemp = (currentWeather.currentTemp - 32) / 1.8
            currentTempLbl.text = "\(Int(round(currentWeather.currentTemp)))º"
            
            // Update forecast
            for day in tenDayForecast {
                day.high = (day.high - 32) / 1.8
                day.low = (day.low - 32) / 1.8
            }
            tableView.reloadData()

            fahrenheitBtn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
            celsiusBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        }
    }
    
    @IBAction func fahrenheitBtnPressed(_ sender: Any) {
        if fahrenheitBtn.currentTitleColor == UIColor.darkGray {
            
            // Update currentTemp
            currentWeather.currentTemp = currentWeather.currentTemp * 1.8 + 32
            currentTempLbl.text = "\(Int(round(currentWeather.currentTemp)))º"
            
            // Update forecast
            for day in tenDayForecast {
                day.high = day.high * 1.8 + 32
                day.low = day.low * 1.8 + 32
            }
            tableView.reloadData()
            
            fahrenheitBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
            celsiusBtn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        }
    }
}
