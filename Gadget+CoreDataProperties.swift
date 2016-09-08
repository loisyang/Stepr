//
//  Gadget+CoreDataProperties.swift
//  StepCounter
//
//  Created by James Ormond on 9/8/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Gadget {

    @NSManaged var name: String?
    @NSManaged var numActive: NSNumber?
    @NSManaged var bonus: NSNumber?
    @NSManaged var cost: NSNumber?
    @NSManaged var unlockLevel: NSNumber?
    @NSManaged var upgradeCost: NSNumber?
    @NSManaged var upgradeLevel: NSNumber?

}
