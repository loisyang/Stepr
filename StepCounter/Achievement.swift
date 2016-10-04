//
//  Achievement.swift
//  Stepr
//
//  Created by James Ormond on 10/3/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Achievement: NSManagedObject {
    
    class func getAllAchievements() -> [Achievement] {
        let context = self.getContext()
        let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Achievement")
        
        let sortDescriptor = NSSortDescriptor(key: "value", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        var results : [AnyObject]?
        
        do {
            // Execute the request
            try results = context.fetch(request)
        } catch _ {
            results = nil
        }
        
        if results != nil && results!.count > 0 {
            return results as! [Achievement]
        } else {
            return []
        }

    }
    
    func isAchieved() -> Bool {
        return true
    }
    
}
