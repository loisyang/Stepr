//
//  Achievement+CoreDataProperties.swift
//  Stepr
//
//  Created by James Ormond on 10/3/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import Foundation
import CoreData

extension Achievement {
    
    @NSManaged var name: String?
    @NSManaged var value: NSNumber?
    @NSManaged var measure: String?
    
}
