//
//  BookMarkedCityViewModel.swift
//  SSMobiquityWeatherApp
//
//  Created by Suraj Shandil on 7/20/21.
//

import Foundation
import CoreLocation
import UIKit

struct BookMarkedCityViewModel {
    let title = "Weather Dashboard"
    let locationManager = LocationManager()
    
    func getBookmarkedLocations() -> [Location] {
        return locationManager.fetchBookmarkedLocations()
    }
    func addLocationAsBookmark(location: Location) {
        locationManager.saveLocationAsBookmark(_location: location)
    }
    func resetAllBookmarkedLocation() {
        locationManager.delete(entityName: "CDLocation")
    }
    func getPlaceMarkFromLocation(location: CLLocation, completionHandler: @escaping (CLPlacemark?)
                                    -> Void ) {
        // Use the last reported location.
        let geocoder = CLGeocoder()
        
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(location,
                                        completionHandler: { (placemarks, error) in
                                            if error == nil {
                                                let firstLocation = placemarks?[0]
                                                completionHandler(firstLocation)
                                            }
                                            else {
                                                // An error occurred during geocoding.
                                                completionHandler(nil)
                                            }
                                        })
    }
    
    
    func deleteLocation(locatinId: String) {
        locationManager.deleteLocationWith(locationId: locatinId, from: "CDLocation")
    }
}
