//
//  WeatherDashboardViewController+Mapview.swift
//  SSMobiquityWeatherApp
//
//  Created by Suraj Shandil on 7/20/21.
//

import Foundation
import MapKit
import CoreLocation

extension WeatherDashboardViewController: CLLocationManagerDelegate {
    func showLocationsOnMap(locations: [Location]) {
        for location in locations {
            DispatchQueue.main.async {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                annotation.title = location.title
                annotation.subtitle = location.subTitle
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    func addAnnotation(location: Location){
        locations.append(location)
        DispatchQueue.main.async {
            self.locationCollectionview.reloadData()
            self.createSnapshotFrom(locations: self.locations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            annotation.title = location.title
            annotation.subtitle = location.subTitle
            self.mapView.addAnnotation(annotation)
        }
    }
    func setDefaultRegionOfMap() {
        DispatchQueue.main.async {
            let defaultLocation = CLLocationCoordinate2D(latitude: 38.8977, longitude: -77.0365)
            let region = MKCoordinateRegion.init(center: defaultLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
            self.mapView.setRegion(region, animated: true)
        }
    }
    func addTapgestureOnMapView() {
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
            mapView.addGestureRecognizer(longTapGesture)
    }
    @objc func longTap(sender: UIGestureRecognizer){
        print("long tap")
        guard settingManger.resetBookMark == false else {
            let alerViewController = UIAlertController(title: "Warning", message: #"Please turnoff "Reset Bookmarked Cities" in Settings page to bookmark new city"#, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                // handle response here.
            }
            alerViewController.addAction(OKAction)
            self.present(alerViewController, animated: true, completion: nil)
            return
        }
        if sender.state == .began {
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            let loc = CLLocation(latitude: locationOnMap.latitude, longitude: locationOnMap.longitude)
            bookmarkedCityViewModel.getPlaceMarkFromLocation(location: loc) {[weak self] (placemark) in
                guard let sSelf = self else { return }
                let locationId = UUID()
                let _location = Location(title: placemark?.locality ?? placemark?.country, subTitle: placemark?.subLocality ?? placemark?.name, latitude: locationOnMap.latitude, longitude: locationOnMap.longitude, locationId: locationId.uuidString)
                sSelf.bookmarkedCityViewModel.addLocationAsBookmark(location: _location)
                DispatchQueue.main.async {
                    sSelf.addAnnotation(location: _location)
                    sSelf.locationCollectionview.reloadData()
                }
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            // you're good to go!
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print("Failed to find user's location: \(error.localizedDescription)")
       }
}
