//
//  LocationManager.swift
//  SSMobiquityWeatherApp
//
//  Created by Suraj Shandil on 7/14/21.
//

import Foundation
import CoreData

final class LocationManager {
    
    let coreDataManager = CoreDataManager()
    func saveLocationAsBookmark(_location: Location) {
        let moc = coreDataManager.moc
        let location = CDLocation(context: moc)
        location.title = _location.title ?? "No Title"
        location.subTitle = _location.subTitle ?? "No SubTitle"
        location.latitude = _location.latitude
        location.longitude = _location.longitude
        location.locationId = _location.locationId
        coreDataManager.saveContext()
    }
    func fetchBookmarkedLocations() -> [Location]  {
        let result = coreDataManager.fetchManagedObject(managedObject: CDLocation.self)
        var locations: [Location] = []
        result?.forEach({ location in
            locations.append(location.convertToLocation())
        })
        return locations
    }
    func delete(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try coreDataManager.persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: coreDataManager.moc)
          debugPrint("Deleted Entitie - ", entityName)
        } catch let error as NSError {
          debugPrint("Delete ERROR \(entityName)")
          debugPrint(error)
        }
    }
    func deleteLocationWith(locationId: String, from entity: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CDLocation")
        request.predicate = NSPredicate(format: "locationId = %@ ", locationId)
        do {
            let records = try coreDataManager.moc.fetch(request) as! [NSManagedObject]
            guard records.count > 0 else {
                return
            }
            for record in records {
                coreDataManager.moc.delete(record)
                coreDataManager.saveContext()
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
        
}
