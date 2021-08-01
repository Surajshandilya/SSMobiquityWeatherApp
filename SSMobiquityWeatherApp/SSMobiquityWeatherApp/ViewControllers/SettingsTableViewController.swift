//
//  SettingsTableViewController.swift
//  WeatherApp
//
//  Created by Suraj Shandil on 7/29/21.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var unitsSegment: UISegmentedControl!
    @IBOutlet weak var mapTypeSegment: UISegmentedControl!
    @IBOutlet weak var resetBookmarkSwitch: UISwitch!
    var settingsManager = SettingsManager.sharedInstance
    // MARK: - View Life Cycles -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavbar()
        self.configureSegmentControlsAndSwitchAppearance()
        self.setupDefaultSettings()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    // MARK: - Private Method Implementation -
    private func configureSegmentControlsAndSwitchAppearance() {
        unitsSegment.selectedSegmentTintColor = .systemTeal
        mapTypeSegment.selectedSegmentTintColor = .systemTeal
        resetBookmarkSwitch.onTintColor = .systemTeal
    }
    private func setupDefaultSettings() {
        unitsSegment.selectedSegmentIndex = settingsManager.unitType == 0 ? 0 : 1
        resetBookmarkSwitch.isOn = settingsManager.resetBookMark == false ? false : true
        mapTypeSegment.selectedSegmentIndex = settingsManager.mapType == 0 ? 0 : 1
    }
    private func setupNavbar() {
        title = "Settings"
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrowtriangle.backward.fill"), style: .plain, target: self, action: #selector(goBack))
        leftBarButtonItem.tintColor = .white
        navigationItem.leftBarButtonItem  = leftBarButtonItem
        navigationController?.navigationBar.barTintColor = .systemGray2
    }
    
    @objc private func goBack() {
        debugPrint(self.navigationController?.viewControllers as Any)
        self.navigationController?.popViewController(animated: true)
    }
    private func reloadTableViewData() {
        tableView.reloadData()
    }
    // MARK: - Table view data source -
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
    }
    // MARK: - UIButton Action -
    @IBAction func unitSegmentIndexChanged(_ sender: Any) {
        let segment = sender as! UISegmentedControl
        if segment.selectedSegmentIndex == 1 {
            settingsManager.unitType = 1
        } else {
            settingsManager.unitType = 0
        }
        self.reloadTableViewData()
    }
    
    @IBAction func mapSegmentIndexChanged(_ sender: Any) {
        let segment = sender as! UISegmentedControl
        if segment.selectedSegmentIndex == 1 {
            settingsManager.mapType = 1
        } else {
            settingsManager.mapType = 0
        }
        self.reloadTableViewData()
    }
    
    @IBAction func resetBookmarkValueChanged(_ sender: Any) {
        let bookmarkSwitch = sender as! UISwitch
        if bookmarkSwitch.isOn {
            settingsManager.resetBookMark = true
        } else {
            settingsManager.resetBookMark = false
        }
        self.reloadTableViewData()
    }

}
