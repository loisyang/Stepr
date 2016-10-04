//
//  History+CoreDataProperties.swift
//  Stepr
//
//  Created by James Ormond on 9/10/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData
import UIKit

extension History {

    @NSManaged var date: Date?
    @NSManaged var steps: NSNumber?
    @NSManaged var points: NSNumber?
    
    class func getContext() -> NSManagedObjectContext {
        let app = (UIApplication.shared.delegate as! AppDelegate)
        return app.managedObjectContext
    }

}
