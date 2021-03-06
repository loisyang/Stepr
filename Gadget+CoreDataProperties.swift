//
//  Gadget+CoreDataProperties.swift
//  Stepr
//
//  Created by James Ormond on 9/8/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData
import UIKit

extension Gadget {

    @NSManaged var name: String?
    @NSManaged var numActive: NSNumber?
    @NSManaged var bonus: NSNumber?
    @NSManaged var cost: NSNumber?
    @NSManaged var unlockLevel: NSNumber?
    @NSManaged var upgradeCost: NSNumber?
    @NSManaged var upgradeLevel: NSNumber?
    
    class func getContext() -> NSManagedObjectContext {
        let app = (UIApplication.shared.delegate as! AppDelegate)
        return app.managedObjectContext
    }

}
