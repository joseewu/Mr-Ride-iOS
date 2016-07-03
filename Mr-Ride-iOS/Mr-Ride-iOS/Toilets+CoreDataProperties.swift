//
//  Toilets+CoreDataProperties.swift
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

extension Toilets {

    @NSManaged var long: NSNumber?
    @NSManaged var lat: NSNumber?
    @NSManaged var toiletName: String?
    @NSManaged var address: String?

}
