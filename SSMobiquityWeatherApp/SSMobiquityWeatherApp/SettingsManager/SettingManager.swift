//
//  SettingManager.swift
//  WeatherApp
//
//  Created by Suraj Shandil on 27/07/21.
//

import Foundation
class SettingsManager {
    static let sharedInstance = SettingsManager()
    private init() {}
    var unitType: Int = 0
    var resetBookMark: Bool = false
    var mapType: Int = 0
}
