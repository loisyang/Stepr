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
        let app = (UIApplication.shared.delegate as! AppDelegate)
        let context = app.managedObjectContext
        let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "History")
        
        // Add the sortDescriptor so that CoreData returns them ordered by points
        // This makes results[0] the highest score
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        var results : [AnyObject]?
        
        do {
            // Execute the request
            try results = context.fetch(request)
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
        let app = (UIApplication.shared.delegate as! AppDelegate)
        let context = app.managedObjectContext
        let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "History")
        
        // Add the sortDescriptor so that CoreData returns them ordered by points
        // This makes results[0] the highest score
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        var results : [AnyObject]?
        
        do {
            // Execute the request
            try results = context.fetch(request)
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
        if let points = UserDefaults.standard.object(forKey: "pointsInWallet") as? Double {
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
     Level 2: 5000 - 15000
     Level 3: 15000 - 38000
     Level 4: 38000 - 98835
     Level 5: 98835 - 283879
     Level 6: 283879 - 931168
     Level 7: 931168 - 3.535 million
     Level 8: 3.535 million - 15.581 million
     Level 9: 15.581 million - 79.665 million
     Level 10: 79.665 million - 471.734 million
     Level 11: 471.734 million - 3.23 billion
     Level 12: 3.23 billion - 25.55 billion
     Level 13: 25.55 billion - 233.226 billion
     Level 14: 233.226 billion - 2.455 trillion
     Level 15: 2.455 trillion - 29.801 trillion
     Level 16: 29.801 trillion - 416.786 trillion
     Level 17: 416.786 trillion - 6.715 quadrillion
     Level 18: 6.715 quadrillion - 124.58 quadrillion
     Level 19: 124.58 quadrillion - 2.661 quintillion
     Level 20: 2.661 quintillion -
     */
    func getUserLevel() -> (level: Int, percentage: Double, pointsToGo: Double) {
        let pointsRanges : [(min: Double, max: Double)] = [
            (0, 5000),
            (5000, 15000),
            (15000, 38000),
            (38000, 98835),
            (98835, 283879),
            (283879, 931168),
            (931168, 3535000), // 931168 - 3.535 million
            (3535000, 15581000), // 3.535 million - 15.581 million
            (15581000, 79665000), // 15.581 million - 79.665 million
            (79665000, 471734000), // 79.665 million - 471.734 million
            (471734000, 3230000000), // 471.734 million - 3.23 billion
            (3230000000, 25550000000), // 3.23 billion - 25.55 billion
            (25550000000, 233226000000), // 25.55 billion - 233.226 billion
            (233226000000, 2455000000000), // 233.226 billion - 2.455 trillion
            (2455000000000, 29801000000000), // 2.455 trillion - 29.801 trillion
            (29801000000000, 416786000000000), // 29.801 trillion - 416.786 trillion
            (416786000000000, 6715000000000000), // 416.786 trillion - 6.715 quadrillion
            (6715000000000000, 124580000000000000), // 6.715 quadrillion - 124.58 quadrillion
            (124580000000000000, 2661000000000000000), // 124.58 quadrillion - 2.661 quintillion
        ]
        
        if let totalPoints = UserDefaults.standard.value(forKey: "totalPointsSinceStart") {
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
        let app = (UIApplication.shared.delegate as! AppDelegate)
        let context = app.managedObjectContext
        let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "History")
        
        // Add the sortDescriptor so that CoreData returns them ordered by points
        // This makes results[0] the highest score
        let sortDescriptor = NSSortDescriptor(key: "points", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        var results : [AnyObject]?
        
        do {
            // Execute the request
            try results = context.fetch(request)
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
