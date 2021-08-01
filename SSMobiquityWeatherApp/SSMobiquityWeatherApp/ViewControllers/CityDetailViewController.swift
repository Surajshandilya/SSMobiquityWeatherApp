//
//  CityDetailViewController.swift
//  WeatherApp
//
//  Created by Suraj Shandil on 7/29/21.
//

import UIKit

class CityDetailViewController: UIViewController {
   
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weather: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var cityDetailsViewModel: CityDetailsViewModel!
    let temperatureConversion = TemparatureConversionUtility()
    var selectedCity: String?
    var todaysData: [List]?
    var weeksData: [List]?
    let settingsManager = SettingsManager.sharedInstance
    var temperatureUnit: Int = 0
    var cityInfo: CityInfo?
    var selctedCity: String?
    var networkStatus: NetworkStatus?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        self.temperatureUnit = settingsManager.unitType == 0 ? 0 : 1
        collectionView.collectionViewLayout = createCompositionalLayout()
        self.todaysData = cityDetailsViewModel.getTodaysTimeAndWeather()
        self.weeksData = cityDetailsViewModel.getWeeksWeatherData()
        setupCityData()
    
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.temperatureUnit = settingsManager.unitType == 0 ? 0 : 1
        collectionView.register(UINib.init(nibName: "ListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ListCollectionViewCell")
        collectionView.register(UINib.init(nibName: "LastFiveDaysTemperatureCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LastFiveDaysTemperatureCollectionViewCell")
    }
    func setupNavigationBar() {
        title = cityDetailsViewModel.selectedCity
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrowtriangle.backward.fill"), style: .plain, target: self, action: #selector(goBack))
        leftBarButtonItem.tintColor = .white
        navigationItem.leftBarButtonItem  = leftBarButtonItem
        navigationController?.navigationBar.barTintColor = .systemGray2
    }
    func setupCityData() {
        let cityData = cityDetailsViewModel.cityInfo?.list.first
        guard let city = cityData else {
            return
        }
        DispatchQueue.main.async {
            self.temperature.text = self.cityDetailsViewModel.getTemperatureWithUnits(temperature: city.main.temp, inUnit: self.temperatureUnit)
            self.humidityLabel.text = String(city.main.humidity)
            guard let weatherDescription = city.weather.first?.weatherDescription.rawValue else {
                return
            }
            self.weather.text = weatherDescription.capitalized
            self.windSpeedLabel.text = String(city.wind.speed)
        }
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
         switch sectionNumber {
         case 0: return self.firstLayoutSection()
         case 1: return self.secondLayoutSection()
         default:
            return nil
         }
       }
    }
}


extension CityDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        switch section {
        case 0:
            count = self.todaysData?.count ?? 0
        case 1:
            count = self.weeksData?.count ?? 0
        default:
            count = 0
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCollectionViewCell", for: indexPath) as! ListCollectionViewCell
            let cityData = self.todaysData?[indexPath.item]
            guard let city = cityData else {
                return UICollectionViewCell()
            }
            self.configureTodaysViewCell(_cell: cell, data: city)
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LastFiveDaysTemperatureCollectionViewCell", for: indexPath) as! LastFiveDaysTemperatureCollectionViewCell
            let weekCityData = self.weeksData?[indexPath.item]
            guard let weekData = weekCityData else {
                return UICollectionViewCell()
            }
            self.configureweekDaysViewCell(_cell: cell, data: weekData)
            return cell
        }
        return UICollectionViewCell()
    }
    func configureTodaysViewCell(_cell: UICollectionViewCell, data: List) {
        let cell = _cell as! ListCollectionViewCell
        cell.setData(_data: data, cityDetailsViewModel: self.cityDetailsViewModel, temperatureUnit: self.temperatureUnit)
    }
    func configureweekDaysViewCell(_cell: UICollectionViewCell, data: List) {
        let cell = _cell as! LastFiveDaysTemperatureCollectionViewCell
        cell.setData(_data: data, cityDetailsViewModel: self.cityDetailsViewModel, temperatureUnit: self.temperatureUnit)
    }
    func firstLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension:
                                                .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
          top: 10,
          leading: 10,
          bottom: 10,
          trailing: 10)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension:
                                                .absolute(160.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    func secondLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension:
                                                .absolute(80))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
          top: 5,
          leading: 10,
          bottom: 5,
          trailing: 10)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension:
                                                .estimated(500))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
}
