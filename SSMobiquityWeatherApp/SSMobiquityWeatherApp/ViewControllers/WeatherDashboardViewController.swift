//
//  WeatherDashboardViewController.swift
//  SSMobiquityWeatherApp
//
//  Created by Suraj Shandil on 7/13/21.
//

import UIKit
import MapKit
import CoreLocation
import Foundation

class WeatherDashboardViewController: UIViewController {
    @IBOutlet weak var noBookmarkedView: UIView!
    @IBOutlet weak var cointainerStackView: UIStackView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationCollectionview: UICollectionView!
    
    let settingManger = SettingsManager.sharedInstance
    var bookmarkedCityViewModel = BookMarkedCityViewModel()
    var dataSource: UICollectionViewDiffableDataSource<Section, Location>!
    var searchController = UISearchController(searchResultsController: nil)
    var locationManager: CLLocationManager?
    let networkHandler = NetworkHandler()
    var cityInfo: CityInfo?
    var selctedCity: String?
    var networkStatus: NetworkStatus?
    var locations: [Location] = [] {
        didSet {
            DispatchQueue.main.async {
                self.noBookmarkedView.isHidden = self.locations.count > 0 ? true : false
            }
        }
    }
    var mapType: Int = 0 {
        didSet {
            DispatchQueue.main.async {
                self.mapView.mapType = self.mapType == 0 ? .standard : .hybrid
            }
        }
    }
    //MARK:- View Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        locationCollectionview.collectionViewLayout = self.createCompositionalLayout()
        self.setupLocationManger()
        locations = bookmarkedCityViewModel.getBookmarkedLocations()
        locationCollectionview.register(UINib.init(nibName: "LocationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LocationCollectionViewCell")
        locationCollectionview.delegate = self
        networkStatus = NetworkStatus.shared
        configureDataSoure()
        self.configureSearchController()
        self.setDefaultRegionOfMap()
        self.createSnapshotFrom(locations: self.locations, animatingDifference: false)
        self.showLocationsOnMap(locations: self.locations)
        self.addTapgestureOnMapView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.setupNavigationBarItem()
        noBookmarkedView.isHidden = locations.count > 0 ? true : false
        if settingManger.resetBookMark == true {
            bookmarkedCityViewModel.resetAllBookmarkedLocation()
            updateBookmarkedList()
        }
        self.mapType = settingManger.mapType
    }
    //MARK:- Private Method Implementation -
    private func updateBookmarkedList() {
        locations = bookmarkedCityViewModel.getBookmarkedLocations()
        DispatchQueue.main.async {
            let annotations = self.mapView.annotations
            self.mapView.removeAnnotations(annotations)
            self.createSnapshotFrom(locations: self.locations)
            self.showLocationsOnMap(locations: self.locations)
        }
    }
    private func updateBookmarkedListAfterDeletingABookmark(loc: Location) {
        locations = bookmarkedCityViewModel.getBookmarkedLocations()
        for annotation in mapView.annotations {
            if annotation.coordinate.latitude == loc.latitude && annotation.coordinate.longitude == loc.longitude {
                mapView.removeAnnotation(annotation)
                self.createSnapshotFrom(locations: self.locations)
                showLocationsOnMap(locations: locations)
            }
        }
        
    }
    private func setupNavigationBarItem() {
        title = bookmarkedCityViewModel.title
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(showSettingsVC))
        rightBarButtonItem.tintColor = .white
        navigationItem.rightBarButtonItem  = rightBarButtonItem

        let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.fill.badge.questionmark"), style: .plain, target: self, action: #selector(showHelpVC))
        leftBarButtonItem.tintColor = .white
        navigationItem.leftBarButtonItem  = leftBarButtonItem
    }
    
    @objc private func showSettingsVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let settingVC = storyboard.instantiateViewController(identifier: "SettingsTableViewController") as? SettingsTableViewController else {
            debugPrint("SettingsTableViewController not found")
            return
        }
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    @objc private func showHelpVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let helpVC = storyboard.instantiateViewController(identifier: "HelpViewController") as? HelpViewController else {
            debugPrint("HelpViewController not found")
            return
        }
        self.navigationController?.pushViewController(helpVC, animated: true)
    }
    
    //MARK: - Private Methods Implementation -
    private func setupLocationManger() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
    }
    
    private func showCityDeatilsVC(cityDetails: CityDetailsViewModel?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let cityDetailVC = storyboard.instantiateViewController(identifier: "CityDetailViewController") as? CityDetailViewController else {
            debugPrint("CityDetailViewController not found")
            return
        }
        guard let cityInfo = cityDetails else { return }
        cityDetailVC.cityDetailsViewModel = cityInfo
        self.navigationController?.pushViewController(cityDetailVC, animated: true)
    }
    private func getCityDetails() {
        if self.networkStatus?.networkEnabled == true {
            self.getCityInfoData(city: self.selctedCity) {(cityInfo) in
                self.removeSpinner()
                let cityDetailViewModel = CityDetailsViewModel()
                cityDetailViewModel.selectedCity = cityInfo.city.name
                cityDetailViewModel.cityInfo = cityInfo
                self.showCityDeatilsVC(cityDetails: cityDetailViewModel)
            }
        } else {
            DispatchQueue.main.async {
                let alerViewController = UIAlertController(title: "Network Error", message: #"Please check the network connection."#, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    // handle response here.
                }
                alerViewController.addAction(OKAction)
                self.present(alerViewController, animated: true, completion: nil)
            }
        }
    }
    private func getCityInfoData(city: String?, completion: @escaping (CityInfo) -> ())  {
        guard let selectedCity = city else {
            return
        }
        DispatchQueue.main.async {
            self.showSpinner(onView: self.view)
        }
        networkHandler.getWeatherReport(for: selectedCity, completion: { (cityDetails) in
            DispatchQueue.main.sync {
                completion(cityDetails)
            }
        })
    }
}

extension WeatherDashboardViewController {
    enum Section {
        case main
    }
}
   

extension WeatherDashboardViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func configureDataSoure() {
        dataSource = UICollectionViewDiffableDataSource<Section, Location>(collectionView: locationCollectionview, cellProvider: { (collectionView, indexPath, location) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationCollectionViewCell", for: indexPath) as? LocationCollectionViewCell
            cell?.delegate = self
            cell?.imageView.image = UIImage(systemName: "mappin.and.ellipse")
            cell?.imageView.tintColor = .systemTeal
            if let title = location.title {
                cell?.locationTitle.text = title
            } else {
                cell?.locationTitle.text = ""
            }
            if let subTitle = location.subTitle {
                cell?.locationSubTitle.text = subTitle
            } else {
                cell?.locationSubTitle.text = ""
            }
            return cell
        })
    }
    func createSnapshotFrom(locations: [Location], animatingDifference: Bool = true) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Location>()
        snapShot.appendSections([.main])
        snapShot.appendItems(locations)
        dataSource.apply(snapShot, animatingDifferences: animatingDifference)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let location = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        selctedCity = location.title
        getCityDetails()
    }
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout(section: self.createFeaturedSection(using: .main))
        return layout
    }
    func createFeaturedSection(using section: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/5))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        return layoutSection
    }
}

//MARK: - LocationCellDelegate -
extension WeatherDashboardViewController: LocationCellDelegate {
    func deleteSelectedLocation(cell: LocationCollectionViewCell) {
        let indexPath = locationCollectionview.indexPath(for: cell)
        guard let index = indexPath?.item else {
            return
        }
        let loc = locations[index]
        bookmarkedCityViewModel.deleteLocation(locatinId: loc.locationId)
        locations.remove(at: index)
        self.updateBookmarkedListAfterDeletingABookmark(loc: loc)
    }
}
