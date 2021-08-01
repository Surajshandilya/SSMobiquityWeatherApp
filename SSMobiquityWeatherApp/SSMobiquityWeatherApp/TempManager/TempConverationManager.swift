//
//  TempConverationManager.swift
//  SSMobiquityWeatherApp
//
//  Created by Suraj Shandil on 7/20/21.
//

import Foundation

struct TempConverationManager {
    func kelvinToCelcius(val: Double) -> String {
        let celcius = Int(val - 273.15)
        return String(celcius) + "°C"
    }
    func kelvinToFahreinheit(val: Double) -> String {
        let celcius = Int(val - 459.67)
        return String(celcius) + "°F"
    }
    func getDateFromDateFormat(dateStr: String, dateFormat: String) -> NSDate {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone?
        let date = dateFormatter.date(from: dateStr) as NSDate?
        return date ?? NSDate()
    }
    func getCityDate(date: Date) -> String {
        return self.timeFromDate(date: date)
    }
    func getDayOfCityDate(date: Date) -> String {
        return getDayFromTheDate(date: date)
    }
    func timeFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dFormat.formatter4
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone?
        let time = dateFormatter.string(from: date)
        return time
    }
    func getDayFromTheDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dFormat.formatter3
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone?
        let dayOfTheWeekString = dateFormatter.string(from: date)
        return dayOfTheWeekString
    }
    func getDateStringToFilterDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dFormat.formatter2
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone?
        let filteredDateStr = dateFormatter.string(from: date)
        return filteredDateStr
    }
}
