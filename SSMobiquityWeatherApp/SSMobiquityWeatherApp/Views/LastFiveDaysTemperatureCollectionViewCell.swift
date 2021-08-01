//
//  LastFiveDaysTemperatureCollectionViewCell.swift
//  SSMobiquityWeatherApp
//
//  Created by Suraj Shandil on 7/20/21.
//

import UIKit

class LastFiveDaysTemperatureCollectionViewCell: UICollectionViewCell {
    let cornerRadius:CGFloat = 10.0
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherIconImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    let temperatureConversion = TemparatureConversionUtility()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Apply rounded corners to contentView
        contentView.layer.cornerRadius = cornerRadius
               contentView.layer.masksToBounds = true
               
               // Set masks to bounds to false to avoid the shadow
               // from being clipped to the corner radius
        layer.cornerRadius = cornerRadius
               layer.masksToBounds = false
               
               // Apply a shadow
               layer.shadowRadius = 8.0
               layer.shadowOpacity = 0.10
               layer.shadowColor = UIColor.black.cgColor
               layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    override func layoutSubviews() {
            super.layoutSubviews()
            
            // Improve scrolling performance with an explicit shadowPath
            layer.shadowPath = UIBezierPath(
                roundedRect: bounds,
                cornerRadius: cornerRadius
            ).cgPath
        }
    func setData(_data: List?, cityDetailsViewModel: CityDetailsViewModel, temperatureUnit: Int) {
        guard let cellData = _data else {
            return
        }
        DispatchQueue.main.async {
            let dayDate = self.temperatureConversion.getDateFromDateFormat(dateStr: cellData.dtTxt , dateFormat: dFormat.formatter1)
            self.dayLabel.text = self.temperatureConversion.getDayFromTheDate(date: dayDate as Date)
            self.temperatureLabel.text = cityDetailsViewModel.getTemperatureWithUnits(temperature: cellData.main.temp , inUnit: temperatureUnit) //self.temperatureConversion.kelvinToCelcius(val: city.main.temp)
            self.humidityLabel.text = String(cellData.main.humidity )
            guard let weatherDescription = cellData.weather.first?.weatherDescription.rawValue else {
               return
            }
            let getIconStr = cityDetailsViewModel.getWeatherIconString(icon: weatherDescription)
            self.weatherIconImage.image = UIImage(systemName: getIconStr)
            self.windLabel.text = String(cellData.wind.speed )
        }
    }

}
