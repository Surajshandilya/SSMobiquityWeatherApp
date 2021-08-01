//
//  ListCollectionViewCell.swift
//  SSMobiquityWeatherApp
//
//  Created by Suraj Shandil on 7/20/21.
//
import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    let cornerRadius:CGFloat = 10.0
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weather: UILabel!
    let temperatureConversion = TemparatureConversionUtility()
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true
        
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
            let cityDate = self.temperatureConversion.getDateFromDateFormat(dateStr: cellData.dtTxt, dateFormat: dFormat.formatter1)
            self.weather.text = self.temperatureConversion.getCityDate(date: cityDate as Date)
            self.temperatureLabel.text = cityDetailsViewModel.getTemperatureWithUnits(temperature: cellData.main.temp, inUnit: temperatureUnit)
            guard let weatherDescription = cellData.weather.first?.weatherDescription.rawValue else {
                return
            }
            let getIconStr = cityDetailsViewModel.getWeatherIconString(icon: weatherDescription)
            self.weatherIcon.image = UIImage(systemName: getIconStr)
        }
    }
}
