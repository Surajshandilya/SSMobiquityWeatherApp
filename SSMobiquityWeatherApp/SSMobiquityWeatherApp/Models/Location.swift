//
//  Location.swift
//  SSMobiquityWeatherApp
//
//  Created by Suraj Shandil on 7/15/21.
//

import Foundation

struct Location: Codable, Hashable {
    var title: String?
    var subTitle: String?
    var latitude: Double
    var longitude: Double
    var locationId: String
}
