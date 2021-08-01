//
//  NetworkHandler.swift
//  SSMobiquityWeatherApp
//
//  Created by Suraj Shandil on 7/29/21.
//

import Foundation
import UIKit

class NetworkHandler {

    private func createURLWithQueryItemsFrom(city: String, apiServiceKey: String) -> URL? {
        let parameters = [
            "q": city,
            "appid": apiServiceKey
        ]
        guard let aURlStr = infoForKey("API_BASE_URL") else { return nil }
        var weatherFeedURLComponents = URLComponents(string: aURlStr)
        weatherFeedURLComponents?.queryItems = .init(parameters)
        return weatherFeedURLComponents?.url ?? nil
    }
    
    func getWeatherReport<T: Codable>(for city: String, completion: @escaping(_ result: T) -> ()) {
        guard let serviceKey = infoForKey("API_SERVICE_KEY") else { return }
        let serviceURL = createURLWithQueryItemsFrom(city: city, apiServiceKey: serviceKey)
        guard let serURL = serviceURL else { return }
        URLSession.shared.dataTask(with: serURL) { (responseData, response, error) in
            if (error == nil && responseData != nil && responseData?.count != 0) {
                let decoder = JSONDecoder()
                do {
                    let cityInfo = try decoder.decode(T.self, from: responseData!)
                    _ = completion(cityInfo)
                } catch let error {
                    debugPrint(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    private func infoForKey(_ key: String) -> String? {
        return (Bundle.main.infoDictionary?[key] as? String)?
            .replacingOccurrences(of: "\\", with: "")
    }
}


extension Array where Element == URLQueryItem {
    init<T: LosslessStringConvertible>(_ dictionary: [String: T]) {
        self = dictionary.map({ (key, value) -> Element in
            URLQueryItem(name: key, value: String(value))
        })
    }
}
