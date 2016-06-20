//
//  RunRecords+CoreDataProperties.swift
//  Mr-Ride-iOS
//
//  Created by josee on 6/12/16.
//  Copyright © 2016 com.josee. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension RunRecords {

    @NSManaged var time: NSNumber?
    @NSManaged var cal: NSNumber?
    @NSManaged var distance: NSNumber?
    @NSManaged var date: String?
    @NSManaged var lat: NSObject?
    @NSManaged var long: NSObject?

}
