//
//  Achievement+CoreDataProperties.swift
//  Stepr
//
//  Created by James Ormond on 10/3/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension Achievement {
    
    @NSManaged var name: String?
    @NSManaged var value: NSNumber?
    @NSManaged var measure: String?
    @NSManaged var bonus: NSNumber?
    
    class func getContext() -> NSManagedObjectContext {
        let app = (UIApplication.shared.delegate as! AppDelegate)
        return app.managedObjectContext
    }
    
    class func getNewObject(context: NSManagedObjectContext) -> Achievement {
        return NSEntityDescription.insertNewObject(forEntityName: "Achievement", into: context) as! Achievement
    }
    
}
