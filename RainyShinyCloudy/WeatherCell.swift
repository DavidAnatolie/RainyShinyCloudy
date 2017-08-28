//
//  WeatherCellTableViewCell.swift
//  RainyShinyCloudy
//
//  Created by David Islam on 2017-08-26.
//  Copyright © 2017 David Islam. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var highLbl: UILabel!
    @IBOutlet weak var lowLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(forecast: Forecast) {
        thumbnail.image = UIImage(named: "\(forecast.thumbnail) Mini")
        dayLbl.text = forecast.day
        typeLbl.text = forecast.type
        highLbl.text = forecast.high
        lowLbl.text = forecast.low
    }

}
