//
//  DashboardModel.swift
//  Stepr
//
//  Created by James Ormond on 9/9/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import HealthKit

class DashboardModel {
    
    let healthKitStore : HKHealthStore = HKHealthStore()
    
    /**
     This function queries the NSUserDefault variable daySteps and returns the number of steps
     the user has taken that day. It returns the steps as an Int.
     */
    func getStepsForToday() -> Int {
        //        if let steps = NSUserDefaults.standardUserDefaults().objectForKey("daySteps") as? Int {
        //            return steps
        //        }
        
        // Create the context
        let app = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context = app.managedObjectContext
        let request = NSFetchRequest(entityName: "History")
        
        // Add the sortDescriptor so that CoreData returns them ordered by points
        // This makes results[0] the highest score
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        var results : [AnyObject]?
        
        do {
            // Execute the request
            try results = context.executeFetchRequest(request)
        } catch _ {
            results = nil
        }
        
        if results != nil && results!.count > 0 {
            let today = results!.first as! History
            return today.steps as! Int
        }
        return 0
    }
    
    /**
     This function queries the NSUserDefault variable daypoints and returns the number of points
     the user has achieved that day. This function floors the number of points, because some Gadgets have
     decimal values in their bonus, so its possible that the actual value for dayPoints is not a
     whole number. It returns the points as a Double.
     */
    func getPointsForToday() -> Double {
        //        if let points = NSUserDefaults.standardUserDefaults().objectForKey("dayPoints") as? Double {
        //            return floor(points)
        //        }
        //        return 0
        
        // Create the context
        let app = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context = app.managedObjectContext
        let request = NSFetchRequest(entityName: "History")
        
        // Add the sortDescriptor so that CoreData returns them ordered by points
        // This makes results[0] the highest score
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        var results : [AnyObject]?
        
        do {
            // Execute the request
            try results = context.executeFetchRequest(request)
        } catch _ {
            results = nil
        }
        
        if results != nil && results!.count > 0 {
            let today = results!.first as! History
            return today.points as! Double
        }
        return 0
    }
    
    /**
     This function queries the NSUserDefault variable pointsInWallet and returns the number of points
     the user has in their wallet. This function floors the number of points, because some Gadgets have
     decimal values in their bonus, so its possible that the actual value for pointsInWallet is not a
     whole number. It returns the points as a Double.
     */
    func getPointsInWallet() -> Double {
        if let points = NSUserDefaults.standardUserDefaults().objectForKey("pointsInWallet") as? Double {
            return floor(points)
        }
        return 0
    }
    
    /**
     This function queries the NSUserDefaults variable totalPointsSinceStart and determines the user's
     level. It also calculates the percentage of completion until the user reaches the next level. It
     returns the user's level as an Int and the completion percentage as a Double.
     
     Below is a structure of the level ranges:
     
     Level 1: 0 - 5000
     Level 2: 5000 - 20000
     Level 3: 20000 - 50000
     Level 4: 50000 - 100000
     Level 5: 100000 - 200000
     Level 6: 200000 - 500000
     Level 7: 500000 - 1 mil
     Level 8: 1 mil - 2 mil
     Level 9: 2 mil - 5 mil
     Level 10: 5 mil - 10 mil
     Level 11: 10 mil - 20 mil
     Level 12: 20 mil - 50 mil
     Level 13: 50 mil - 100 mil
     Level 14: 100 mil - 500 mil
     Level 15: 500 mil - 1 bil
     Level 16: 1 bil - 10 bil
     Level 17: 10 bil - 100 bil
     Level 18: 100 bil - 1 tril
     Level 19: 1 tril - 1 quad
     Level 20: 1 quad -
     */
    func getUserLevel() -> (level: Int, percentage: Double, pointsToGo: Double) {
        let pointsRanges : [(min: Double, max: Double)] = [
            (0, 5000),
            (5000, 20000),
            (20000, 50000),
            (50000, 100000),
            (100000, 200000),
            (200000, 500000),
            (500000, 1000000), // 1 mil
            (1000000, 2000000), // 2 mil
            (2000000, 5000000), // 5 mil
            (5000000, 10000000), // 10 mil
            (10000000, 20000000), // 20 mil
            (20000000, 50000000), // 50 mil
            (50000000, 100000000), // 100 mil
            (100000000, 500000000), // 500 mil
            (500000000, 1000000000), // 1 bil
            (1000000000, 10000000000), // 10 bil
            (10000000000, 100000000000), // 100 bil
            (100000000000, 1000000000000), // 1 tril
            (1000000000000, 1000000000000000), // 1 quad
        ]
        
        if let totalPoints = NSUserDefaults.standardUserDefaults().valueForKey("totalPointsSinceStart") {
            let points = totalPoints as! Double
            for level in 0..<pointsRanges.count {
                if pointsRanges[level].min <= points && points < pointsRanges[level].max {
                    let range = pointsRanges[level]
                    let userLevel = level + 1
                    let percentage = Double((points - range.min)) / Double(range.max)
                    let pointsToGo = range.max - points
                    return (level: userLevel, percentage: percentage, pointsToGo: pointsToGo)
                }
            }
            return (20, 1, 0.0)
        }
        return (0, 0.0, 0.0)
        
    }
    
    /**
     This function queries the CoreData for all History objects, determines the History object with
     the highest score, and then returns that obeject as a History object. The returned History object
     is an optional, because it is possible that there are no objects in the History CoreData.
     */
    func getHighScore() -> History? {
        
        // Create the context
        let app = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context = app.managedObjectContext
        let request = NSFetchRequest(entityName: "History")
        
        // Add the sortDescriptor so that CoreData returns them ordered by points
        // This makes results[0] the highest score
        let sortDescriptor = NSSortDescriptor(key: "points", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        var results : [AnyObject]?
        
        do {
            // Execute the request
            try results = context.executeFetchRequest(request)
        } catch _ {
            results = nil
        }
        
        if results != nil && results!.count > 0 {
            return results?.first as? History
        } else {
            return nil
        }
    }
    
}