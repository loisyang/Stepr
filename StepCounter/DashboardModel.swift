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
     This function uses the NSUserDefaults variable "lastUpdateDate" as an achor point
     and reads the number steps the user has taken since that anchor point.
     */
    func pullStepsAndUpdate() {
        // first make sure that Apple HealthKit is authorized by the user
        self.authorizeHealthKit { (authorized,  error) -> Void in
            if authorized {
                print("HealthKit authorization accepted!")
                self.updateSteps()
            } else {
                print("HealthKit authorization denied!")
                if error != nil {
                    print("\(error)")
                }
            }
        }
    }
    
    /**
     This function requests reading access from Apple HealthKit. It only requests reading access
     for step count; no writing requests are made.
     */
    private func authorizeHealthKit(completion: ((success:Bool, error:NSError!) -> Void)!) {
        
        let healthKitTypesToRead : Set<HKObjectType> = [
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!
        ]
        
        // check to see if the HealthKit data is available; if not, return completion is false
        if !HKHealthStore.isHealthDataAvailable() {
            let error = NSError(domain: "com.jmsormond.Stepr", code: 2, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available in this Device"])
            if completion != nil {
                completion(success:false, error:error)
            }
            return
        }
        
        // make the actual request to HealthKit for the read data
        self.healthKitStore.requestAuthorizationToShareTypes(nil, readTypes: healthKitTypesToRead) { (success, error) -> Void in
            
            if completion != nil {
                completion(success:success,error:error)
            }
        }
    }
    
    func executeHealthKitRequest() {
        
        // Get the lastUpdateDateObject
        let lastDateObject = NSUserDefaults.standardUserDefaults().objectForKey("lastUpdateDate")
        
        if lastDateObject != nil {
            // Convert it to an NSDate
            let lastDate = lastDateObject as! NSDate
            let currentDate = NSDate()
            
            // The type of data we are requesting
            let type = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
            
            //  Set the Interval
            let interval: NSDateComponents = NSDateComponents()
            interval.day = 1
            
            // Build the query
            let query = HKStatisticsCollectionQuery(quantityType: type!, quantitySamplePredicate: nil, options: [.CumulativeSum], anchorDate: lastDate, intervalComponents:interval)
            
            // Give the query a callback function
            query.initialResultsHandler = { query, results, error in
                
                if error != nil {
                    
                    //  Something went Wrong
                    return
                }
                
                results?.enumerateStatisticsFromDate(lastDate, toDate: currentDate, withBlock: {
                    results, error in
                    
                    // TODO: add in the edge case where the lastDate and currentDate pass through midnight (2 days)
                    
                    if let quantity = results.sumQuantity() {
                        // The query was successful!
                        
                        let steps = quantity.doubleValueForUnit(HKUnit.countUnit())
                        print(steps)
                        
                        // Update the NSUserDefault variables
                        
                        // Update lastUpdateDate
                        NSUserDefaults.standardUserDefaults().setObject(currentDate, forKey: "lastUpdateDate")
                        
                        // TODO: call function from Gadgets Model to convert steps to points
                        // let points = GadgetModel.calculatePoints(steps)
                        // let dayPoints = NSUserDefaults.standardUserDefaults().objectForKey("dayPoints") as! Double
                        // NSUserDefaults.standardUserDefaults().setValue(0.0, forKey: "dayPoints")
                        // let totalPointsSinceStart = NSUserDefaults.standardUserDefaults().objectForKey("totalPointsSinceStart") as! Double
                        // NSUserDefaults.standardUserDefaults().setValue(totalPointsSinceStart + points, forKey: "totalPointsSinceStart")
                        // let pointsInWallet = NSUserDefaults.standardUserDefaults().objectForKey("pointsInWallet") as! Double
                        // NSUserDefaults.standardUserDefaults().setValue(0, forKey: "pointsInWallet")
                        
                        // Update the day steps
                        let daySteps = NSUserDefaults.standardUserDefaults().objectForKey("daySteps") as! Int
                        NSUserDefaults.standardUserDefaults().setValue(daySteps + Int(steps), forKey: "daySteps")
                        
                        // Send the notification to the user
                        let notification = UILocalNotification()
                        notification.alertBody = "\(steps) new steps from HealthKit"
                        notification.alertAction = "open"
                        notification.fireDate = NSDate(timeIntervalSinceNow: 10)
                        notification.soundName = UILocalNotificationDefaultSoundName
                        
                        UIApplication.sharedApplication().scheduleLocalNotification(notification)
                        
                        
                    }
                    
                })
            }
            
            // Execute the query
            self.healthKitStore.executeQuery(query)
            
        } else {
            // TODO: handle this situation
            print("no last update date")
        }

    }
    
    func stepChangedHandler(query: HKObserverQuery, completionHandler: HKObserverQueryCompletionHandler, error: NSError?) {
        
        // Here you need to call a function to query the step change
        self.executeHealthKitRequest()
        
        completionHandler()
        
    }
    
    /**
     This function makes the call to Apple HealthKit and gets all the steps taken since the
     lastUpdateDate. It then updates the appropriate NSUserDefault variables to reflect the
     new data.
     */
    private func updateSteps() {
        
        let sampleType =  HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        
        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType!, predicate: nil, updateHandler: self.stepChangedHandler)
        
        self.healthKitStore.executeQuery(query)
        self.healthKitStore.enableBackgroundDeliveryForType(sampleType!, frequency: .Immediate, withCompletion: {(succeeded: Bool, error: NSError?) in
            
            if succeeded {
                print("Enabled background delivery of step changes")
            } else {
                if let theError = error {
                    print("Failed to enable background delivery of step changes. ")
                    print("Error = \(theError)")
                }
            }
        })
        
    }
    
    /**
     This function queries the NSUserDefault variable daySteps and returns the number of steps
     the user has taken that day. It returns the steps as an Int.
     */
    func getStepsForToday() -> Int {
        if let steps = NSUserDefaults.standardUserDefaults().objectForKey("daySteps") as? Int {
            return steps
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
        if let points = NSUserDefaults.standardUserDefaults().objectForKey("dayPoints") as? Double {
            return floor(points)
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
    func getUserLevel() -> (level: Int, percentage: Double) {
        let pointsRanges : [Range<Int>] = [
            0..<5000,
            5000..<20000,
            20000..<50000,
            50000..<100000,
            100000..<200000,
            200000..<500000,
            500000..<1000000, // 1 mil
            1000000..<2000000, // 2 mil
            2000000..<5000000, // 5 mil
            5000000..<10000000, // 10 mil
            10000000..<20000000, // 20 mil
            20000000..<50000000, // 50 mil
            50000000..<100000000, // 100 mil
            100000000..<500000000, // 500 mil
            500000000..<1000000000, // 1 bil
            1000000000..<10000000000, // 10 bil
            10000000000..<100000000000, // 100 bil
            100000000000..<1000000000000, // 1 tril
            1000000000000..<1000000000000000, // 1 quad
        ]
        
        if let totalPoints = NSUserDefaults.standardUserDefaults().valueForKey("totalPointsSinceStart") {
            let points = totalPoints as! Int
            for level in 0..<pointsRanges.count {
                if pointsRanges[level].contains(points) {
                    let range = pointsRanges[level]
                    let userLevel = level + 1
                    let percentage = Double((points - range.first!)) / Double(range.last!)
                    return (level: userLevel, percentage: percentage)
                }
            }
            return (20, 100)
        }
        return (0, 0.0)
        
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
        
        if results != nil {
            return results?.first as? History
        } else {
            return nil
        }
    }
    
}