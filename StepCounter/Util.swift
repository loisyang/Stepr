//
//  Util.swift
//  Stepr
//
//  Created by James Ormond on 9/8/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import Foundation
import HealthKit
import UIKit
import CoreData

class Util {
    
    /**
     This function is called every time the application starts up. It checks to see whether
     the NSUserDefaults variables and CoreData have been established. If they haven't been,
     then they are initialized; if they have been, then the function does nothing.
     */
    class func initiateDataStructure() {
        // check if data structure has been established
        let established = NSUserDefaults.standardUserDefaults().objectForKey("dataStructureInPlace")
        
        if established == nil {
            // data structure has not been established
            
            // Step 1: Build all NSUserDefaults variables
            
            // let currentDate = NSDate()
            
            // use yesterday's data for testing purposes
            let startOfDay = NSCalendar.currentCalendar().startOfDayForDate(NSDate())
            
            NSUserDefaults.standardUserDefaults().setObject(startOfDay, forKey: "downloadDate")
            
            NSUserDefaults.standardUserDefaults().setValue(0, forKey: "totalPointsSinceStart")
            NSUserDefaults.standardUserDefaults().setValue(0.0, forKey: "pointsInWallet")
            
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "hasWatchedTutorial")
            
            // Step 2: Build all gadgets into CoreData
            let app = (UIApplication.sharedApplication().delegate as! AppDelegate)
            let context = app.managedObjectContext
            let gadgets : [(String, Double, Double, Int)] = [
                ("Protein Bar",         50,          0.1,       1),
                ("Gust of Wind",        1000,        0.2,       2),
                ("Companion Walker",    5000,        1,         3),
                ("Dog",                 250000,      1.5,       4),  //2.5 * 10^5
                ("Horse",               500000,      2,         5),  //5 * 10^5
                ("Running Shoes",       1000000,     3,         6),  //10 * 10^5
                ("5 Hour Energy",       1500000,     4,         7),  //15 * 10^5
                ("Moon boots",          2500000,     6,         8),  //25 * 10^5
                ("Bike",                5000000,     8,         9),  //50 * 10^5
                ("Adrenaline Shot",     100000000,   25,        10), //10 * 10^7
                ("Bird",                150000000,   75,        11), // 15 * 10^7
                ("Pogo Stick",          160000000,   125,       12), //16 * 10^7
                ("Skateboard",          200000000,   150,       13), //20 * 10^7
                ("Wings",               500000000,   200,       14), //50 * 10^7
                ("Carrot on a Stick",   750000000,   300,       15), //75 * 10^7
                ("Thighs of Steel",     900000000,   500,       16), //90 * 10^7
                ("Airplane",            1000000000,  600,       17), // 10 * 10^8
                ("Flying Carpet",       1500000000,  750,       18), // 15 * 10^8
                ("Family",              2000000000,  1000,      19), // 20 * 10^8
                ("Marathon",            3000000000,  2500,      20)  //30 * 10^8
            ]
            
            for gadgetInfo in gadgets {
                let gadget = NSEntityDescription.insertNewObjectForEntityForName("Gadget", inManagedObjectContext: context) as! Gadget
                gadget.name = gadgetInfo.0
                gadget.cost = gadgetInfo.1
                gadget.bonus = gadgetInfo.2
                gadget.unlockLevel = gadgetInfo.3
            }
            do {
                try context.save()
            } catch _ {}
            
            // Step 3: Set dataStructureInPlace to true
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "dataStructureInPlace")
        }
    }
    
    /**
     This function requests reading access from Apple HealthKit. It only requests reading access
     for step count; no writing requests are made.
     */
    class func authorizeHealthKit(completion: ((success:Bool, error:NSError!) -> Void)!) {
        
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
        HKHealthStore().requestAuthorizationToShareTypes(nil, readTypes: healthKitTypesToRead) { (success, error) -> Void in
            
            if completion != nil {
                completion(success:success,error:error)
            }
        }
    }
    
    /**
     This function is what actually calls HealthKit and request thes users steps for that day.
     It uses the start of the day as the anchor point, and requests steps until the current
     moment.
     If there is no History object for the current day, it creates a new one and populates it
     appropriately. If one exists, it updates it appropriately.
     */
    class func executeHealthKitRequest() {
        
        // TODO: There is potential for a bug to be here. If it is querying only for the steps
        // that day, with the last query being at 11:00pm, and this query being at 1:00am, it
        // will miss the steps between 11:01pm and 11:59pm, beecause those are now techincally
        // from the previous day. Fix this in the future.
        
        // Get NSDate for start of current day
        let startOfDay = NSCalendar.currentCalendar().startOfDayForDate(NSDate())
        let currentDate = NSDate()
        
        // The type of data we are requesting
        let type = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        
        //  Set the Interval
        let interval: NSDateComponents = NSDateComponents()
        interval.day = 1
        
        // Build the query
        let query = HKStatisticsCollectionQuery(quantityType: type!, quantitySamplePredicate: nil, options: [.CumulativeSum], anchorDate: startOfDay, intervalComponents:interval)
        
        // Give the query a callback function
        query.initialResultsHandler = { query, results, error in
            
            if error != nil {
                
                //  Something went Wrong
                return
            }
            
            results?.enumerateStatisticsFromDate(startOfDay, toDate: currentDate, withBlock: {
                results, error in
                
                // TODO: add in the edge case where the lastDate and currentDate pass through midnight (2 days)
                
                if let quantity = results.sumQuantity() {
                    // The query was successful!
                    
                    let steps = quantity.doubleValueForUnit(HKUnit.countUnit())
                    
                    // Convert to points
                    let points = Gadget.calculatePoints(Int(steps))
                    
                    // Update lastUpdateDate
                    NSUserDefaults.standardUserDefaults().setObject(currentDate, forKey: "lastUpdateDate")
                    
                    // Update the day steps
                    
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
                        // There already exists a History object, so check if its for this date
                        
                        let today = results!.first as! History
                        let current = NSCalendar.currentCalendar()
                        
                        if current.isDateInToday(today.date!) {
                            // History object is for today, so update that object
                            
                            let oldSteps = today.steps as! Int
                            let newSteps = Int(steps) - oldSteps
                            
                            let newPoints = Gadget.calculatePoints(newSteps)
                            
                            let previousPoints = today.points as! Double
                            
                            today.setValue(Int(steps), forKey: "steps")
                            today.setValue(Double(previousPoints + newPoints), forKey: "points")
                            
                            // update pointsInWallet and totalStepsSinceStart
                            Util.updatePointsInWallet(newPoints)
                            Util.updateTotalPointsSinceStart(newPoints)
                        } else {
                            // History object is not for today, so create a new object for today
                            
                            
                            
                            let history = NSEntityDescription.insertNewObjectForEntityForName("History", inManagedObjectContext: context) as! History
                            history.date = NSDate()
                            history.steps = Int(steps)
                            history.points = Double(points)
                            
                            // update pointsInWallet and totalStepsSinceStart
                            Util.updatePointsInWallet(points)
                            Util.updateTotalPointsSinceStart(points)
                        }
                        
                        do {
                            try context.save()
                        } catch _ {}
                        
                    } else {
                        // There does not exist a History object for this date, so create it
                        
                        let history = NSEntityDescription.insertNewObjectForEntityForName("History", inManagedObjectContext: context) as! History
                        history.date = NSDate()
                        history.steps = Int(steps)
                        history.points = Double(points)
                        
                        // update pointsInWallet and totalStepsSinceStart
                        Util.updatePointsInWallet(points)
                        Util.updateTotalPointsSinceStart(points)
                        
                        do {
                            try context.save()
                        } catch _ {}
                    }
                    
                }
                
            })
        }
        
        // Execute the query
        HKHealthStore().executeQuery(query)
        
    }
    
    /**
     This function is used by HealthKit as the callback for the HKObserverQuery.
     Whenever HealthKit tells this app that there is new data to be requested,
     this function gets called. It calls self.executeHealthKitRequest() to make
     the actual request for the data.
     */
    class func stepChangedHandler(query: HKObserverQuery, completionHandler: HKObserverQueryCompletionHandler, error: NSError?) {
        
        // Call the function to actually query HealthKit for the new data
        Util.executeHealthKitRequest()
        
        completionHandler()
        
    }
    
    /**
     This function makes the call to Apple HealthKit and gets all the steps taken since the
     lastUpdateDate. It then updates the appropriate NSUserDefault variables to reflect the
     new data.
     */
    class func setUpObserverQuery() {
        
        let sampleType =  HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        
        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType!, predicate: nil, updateHandler: Util.stepChangedHandler)
        
        HKHealthStore().executeQuery(query)
        HKHealthStore().enableBackgroundDeliveryForType(sampleType!, frequency: .Immediate, withCompletion: {(succeeded: Bool, error: NSError?) in
            
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
     This function takes a change in the pointsInWallet variable and adds that change
     to the NSUserDefaults variable.
     */
    class func updatePointsInWallet(change: Double) {
        
        let walletPoints = NSUserDefaults.standardUserDefaults().valueForKey("pointsInWallet") as! Double
        let newWalletTotal = walletPoints + change
        
        NSUserDefaults.standardUserDefaults().setValue(newWalletTotal, forKey: "pointsInWallet")
    }
    
    /**
     This function takes a change in the totalPointsSinceStart variable and adds that change
     to the NSUserDefaults variable. It also fires notifications in two scenarios:
        1. If the user just unlocked a new level
        2. If the user has reached the 50% mark for unlocking the next level
     */
    class func updateTotalPointsSinceStart(change: Double) {
        let dashboard = DashboardModel()
        let oldUserLevel = dashboard.getUserLevel()
        
        let totalPoints = NSUserDefaults.standardUserDefaults().valueForKey("totalPointsSinceStart") as! Double
        let newTotal = totalPoints + change
        
        NSUserDefaults.standardUserDefaults().setValue(newTotal, forKey: "totalPointsSinceStart")
        
        let newUserLevel = dashboard.getUserLevel()
        
        if newUserLevel.level > oldUserLevel.level {
            // Create a notification that a new level has been reached!
            
            let notification = UILocalNotification()
            notification.alertBody = "Congrats! You just leveled up to Level \(newUserLevel.level)! Check out the Gadget store to see what you have unlocked!"
            notification.alertAction = "open"
            notification.fireDate = NSDate(timeIntervalSinceNow: 60)
            notification.soundName = UILocalNotificationDefaultSoundName
            
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            
        } else if oldUserLevel.percentage < 0.5 && newUserLevel.percentage >= 0.5 {
            // Create a notification that they just passed 50% completion of the current level
            
            // Send the notification to the user
            let notification = UILocalNotification()
            notification.alertBody = "You're on a roll! You just reached the half way point to Level \(newUserLevel.level + 1). Keep up the good work!"
            notification.alertAction = "open"
            notification.fireDate = NSDate(timeIntervalSinceNow: 60)
            notification.soundName = UILocalNotificationDefaultSoundName
            
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            
        }
    }
    
    class func formatNumber(number: Double) -> String {
        var short = number
        var string = ""
        if 1000000 <= number && number < 1000000000 {
            short = number / 1000000
            string = " million"
        } else if 1000000000 <= number && number < 1000000000000 {
            short = number / 1000000000
            string = " billion"
        } else if 1000000000000 <= number && number < 1000000000000000 {
            short = number / 1000000000000
            string = " trillion"
        } else if 1000000000000000 <= number && number < 1000000000000000000 {
            short = number / 1000000000000000
            string = " quadrillion"
        } else if 1000000000000000000 <= number && number < 1000000000000000000000 {
            short = number / 1000000000000000000
            string = " quintillion"
        } else if 1000000000000000000000 <= number && number < 1000000000000000000000000 {
            short = number / 1000000000000000000000
            string = " sextillion"
        } else if 1000000000000000000000000 <= number && number < 1000000000000000000000000000 {
            short = number / 1000000000000000000000000
            string = " septillion"
        } else if 1000000000000000000000000000 <= number && number < 1000000000000000000000000000000 {
            short = number / 1000000000000000000000000000
            string = " octillion"
        } else if 1000000000000000000000000000000 <= number && number < 1000000000000000000000000000000000 {
            short = number / 1000000000000000000000000000000
            string = " nonillion"
        } else if 1000000000000000000000000000000000 <= number && number < 1000000000000000000000000000000000000 {
            short = number / 1000000000000000000000000000000000
            string = " decillion"
        }
        
        if short - Double(Int(short)) == 0 {
            return "\(Int(short))\(string)"
        } else {
            return "\(Double(round(1000*short)/1000))\(string)"
        }
    }
    
}