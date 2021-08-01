//
//  CityDetailsViewModel.swift
//  SSMobiquityWeatherApp
//
//  Created by Suraj Shandil on 7/20/21.
//

import Foundation

typealias dFormat = AppConstants.DateFormatter
enum WeatherIcon: String {
    case brokenClouds = "broken clouds"
    case clearSky = "clear sky"
    case fewClouds = "few clouds"
    case lightRain = "light rain"
    case overcastClouds = "overcast clouds"
    case scatteredClouds = "scattered clouds"
}

class CityDetailsViewModel {
    var selectedCity: String?
    var cityInfo: CityInfo?
    var todayCityData: [List]?
    var weeksCityData: [List]?
    let temperatureHandler = TemparatureConversionUtility()
    func getTemperatureWithUnits(temperature: Double, inUnit: Int) -> String {
        var temp = ""
        switch inUnit {
        case 1:
            temp = temperatureHandler.kelvinToFahreinheit(val: temperature)
        default:
            temp = temperatureHandler.kelvinToCelcius(val: temperature)
        }
        return temp
    }
    func getWeatherIconString(icon: String) -> String {
        var iconStr = ""
        switch icon {
        case WeatherIcon.brokenClouds.rawValue:
            iconStr = "smoke.fill"
        case WeatherIcon.clearSky.rawValue:
            iconStr = "sun.max.fill"
        case WeatherIcon.fewClouds.rawValue:
            iconStr = "cloud.fill"
        case WeatherIcon.lightRain.rawValue:
            iconStr = "cloud.rain.fill"
        case WeatherIcon.overcastClouds.rawValue:
            iconStr = "cloud.heavyrain.fill"
        case WeatherIcon.scatteredClouds.rawValue:
            iconStr = "cloud.sun.fill"
        default:
            break
        }
        return iconStr
    }
    func getDayItemsFromTheList() -> [String : [List]]? {
        var filteredList = [String : [List]]()
        guard let lists = self.cityInfo?.list else {
            return nil
        }
        let cityDates = lists.map({ return temperatureHandler.getDateFromDateFormat(dateStr: $0.dtTxt, dateFormat: dFormat.formatter1)})
        var fList: [List] = [List]()
        for date in cityDates {
            print("Date: \(date)")
            let convertedDate = temperatureHandler.getDateStringToFilterDate(date: date as Date)
            fList.removeAll()
            for cityList in lists {
                let cityDate = cityList.dtTxt.split(separator: " ").first
                guard let cDate = cityDate else {
                    return nil
                }
                if cDate == convertedDate {
                    fList.append(cityList)
                }
            }
            filteredList[convertedDate] = fList
        }
        return filteredList
    }
    func getTodaysTimeAndWeather() -> [List] {
        let todayDate = temperatureHandler.getDateStringToFilterDate(date: Date())
        let filteredData = self.getDayItemsFromTheList()
        self.todayCityData = filteredData?[todayDate]
        return self.todayCityData ?? []
    }
    func getWeeksWeatherData() -> [List] {
        var weeksData = [List]()
        let filteredData = self.getDayItemsFromTheList()
        guard let keys = filteredData?.keys else {
            return []
        }
        for key in keys {
            let data = filteredData?[key]?.first
            guard let dData = data else {
                return []
            }
            weeksData.append(dData)
        }
        
        self.weeksCityData = weeksData.sorted(by: { $0.dt < $1.dt })
        self.weeksCityData?.remove(at: 0)
        return self.weeksCityData ?? []
    }
}
