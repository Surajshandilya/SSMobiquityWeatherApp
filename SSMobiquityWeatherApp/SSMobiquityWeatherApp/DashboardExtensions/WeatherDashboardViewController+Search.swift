//
//  WeatherDashboardViewController+Search.swift
//  SSMobiquityWeatherApp
//
//  Created by Suraj Shandil on 7/20/21.
//

import Foundation
import UIKit

extension WeatherDashboardViewController: UISearchResultsUpdating {
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search city"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    func filteredLocations(for queryOrNil: String?) -> [Location] {
        let cities = bookmarkedCityViewModel.getBookmarkedLocations()
        guard
            let query = queryOrNil,
            !query.isEmpty
        else {
            return cities
        }
        return cities.filter {
            return $0.title?.lowercased().contains(query.lowercased()) ?? false
        }
    }
    func updateSearchResults(for searchController: UISearchController) {
        locations = filteredLocations(for: searchController.searchBar.text)
        createSnapshotFrom(locations: locations)
    }
}
