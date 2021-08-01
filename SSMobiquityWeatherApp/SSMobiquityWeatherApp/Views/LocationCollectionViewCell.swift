//
//  LocationCollectionViewCell.swift
//  SSMobiquityWeatherApp
//
//  Created by Suraj Shandil on 7/20/21.
//

import UIKit
protocol LocationCellDelegate: AnyObject {
    func deleteSelectedLocation(cell: LocationCollectionViewCell)
}

class LocationCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var locationTitle: UILabel!
    @IBOutlet weak var locationSubTitle: UILabel!
    weak var delegate: LocationCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func deleteRecord(_ sender: Any) {
        delegate?.deleteSelectedLocation(cell: self)
    }
}
