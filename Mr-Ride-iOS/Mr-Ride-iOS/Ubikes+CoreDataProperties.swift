//
//  Ubikes+CoreDataProperties.swift
//  Mr-Ride-iOS
//
//  Created by josee on 6/28/16.
//  Copyright © 2016 com.josee. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Ubikes {

    @NSManaged var name: String?
    @NSManaged var roadName: String?
    @NSManaged var numbers: NSNumber?
    @NSManaged var lat: NSNumber?
    @NSManaged var long: NSNumber?

}
