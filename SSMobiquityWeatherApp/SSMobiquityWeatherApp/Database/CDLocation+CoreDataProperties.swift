//
//  CDLocation+CoreDataProperties.swift
//  SSMobiquityWeatherApp
//
//  Created by Suraj Shandil on 7/20/21.
//
//

import Foundation
import CoreData


extension CDLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDLocation> {
        return NSFetchRequest<CDLocation>(entityName: "CDLocation")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var locationId: String?
    @NSManaged public var longitude: Double
    @NSManaged public var subTitle: String?
    @NSManaged public var title: String?

    func convertToLocation() -> Location {
        return Location(title: self.title, subTitle: self.subTitle, latitude: self.latitude, longitude: self.longitude, locationId: self.locationId ?? "0")
    }
}

extension CDLocation : Identifiable {

}
