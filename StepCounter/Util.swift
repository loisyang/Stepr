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
        let established = UserDefaults.standard.object(forKey: "dataStructureInPlace")
        
        if established == nil {
            // data structure has not been established
            
            // Step 1: Build all NSUserDefaults variables
            
            // let currentDate = NSDate()
            
            // use yesterday's data for testing purposes
            let startOfDay = Calendar.current.startOfDay(for: Date())
            
            UserDefaults.standard.set(startOfDay, forKey: "downloadDate")
            
            UserDefaults.standard.setValue(0, forKey: "totalPointsSinceStart")
            UserDefaults.standard.setValue(0.0, forKey: "pointsInWallet")
            
            UserDefaults.standard.set(false, forKey: "hasWatchedTutorial")
            
            // Step 2: Build all gadgets into CoreData
            let app = (UIApplication.shared.delegate as! AppDelegate)
            let context = app.managedObjectContext
            let gadgets : [(String, Double, Double, Int)] = [
                ("Protein Bar",         500,                  0.1,       1),
                ("Gust of Wind",        5000,                 0.2,       2),
                ("Companion Walker",    15000,                1,         3),
                ("Dog",                 38000,                1.5,       4),
                ("Horse",               98835,                2,         5),
                ("Running Shoes",       283879,               3,         6),
                ("5 Hour Energy",       931165,               4,         7),
                ("Moon Boots",          3535011,              6,         8),
                ("Bike",                15580719,             8,         9),
                ("Adrenaline Shot",     79664364,             25,        10),
                ("Bird",                471731034,            75,        11),
                ("Pogo Stick",          3230215120,           125,       12),
                ("Skateboard",          25549428385,          150,       13),
                ("Wings",               233224859907,         200,       14),
                ("Carrot on a Stick",   2455455858716,        300,       15),
                ("Thighs of Steel",     29801286620975,       500,       16),
                ("Airplane",            416783391339487,      600,       17),
                ("Flying Carpet",       6714577862294450,     750,       18),
                ("Family",              124579323859598000,   1000,      19),
                ("Marathon",            2661326620876080000,  2500,      20)
            ]
            
            for gadgetInfo in gadgets {
                let gadget = NSEntityDescription.insertNewObject(forEntityName: "Gadget", into: context) as! Gadget
                gadget.name = gadgetInfo.0
                gadget.cost = gadgetInfo.1 as NSNumber?
                gadget.bonus = gadgetInfo.2 as NSNumber?
                gadget.unlockLevel = gadgetInfo.3 as NSNumber?
            }
            do {
                try context.save()
            } catch _ {}
            
            // Step 3: Build all Achievements
            
            // Step 4: Set dataStructureInPlace to true
            UserDefaults.standard.set(true, forKey: "dataStructureInPlace")
        }
    }
    
    /**
     This function requests reading access from Apple HealthKit. It only requests reading access
     for step count; no writing requests are made.
     */
    class func authorizeHealthKit(_ completion: ((_ success:Bool, _ error:NSError?) -> Void)!) {
        
        let healthKitTypesToRead : Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        ]
        
        // check to see if the HealthKit data is available; if not, return completion is false
        if !HKHealthStore.isHealthDataAvailable() {
            let error = NSError(domain: "com.jmsormond.Stepr", code: 2, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available in this Device"])
            if completion != nil {
                completion?(false, error)
            }
            return
        }
        
        // make the actual request to HealthKit for the read data
        HKHealthStore().requestAuthorization(toShare: nil, read: healthKitTypesToRead) { (success, error) -> Void in
            
            if completion != nil {
                completion?(success, error as NSError?)
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
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let currentDate = Date()
        
        // The type of data we are requesting
        let type = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        
        //  Set the Interval
        var interval: DateComponents = DateComponents()
        interval.day = 1
        
        // Build the query
        let query = HKStatisticsCollectionQuery(quantityType: type!, quantitySamplePredicate: nil, options: [.cumulativeSum], anchorDate: startOfDay, intervalComponents:interval)
        
        // Give the query a callback function
        query.initialResultsHandler = { query, results, error in
            
            if error != nil {
                
                //  Something went Wrong
                return
            }
            
            results?.enumerateStatistics(from: startOfDay, to: currentDate, with: {
                results, error in
                
                // TODO: add in the edge case where the lastDate and currentDate pass through midnight (2 days)
                
                if let quantity = results.sumQuantity() {
                    // The query was successful!
                    
                    let steps = quantity.doubleValue(for: HKUnit.count())
                    
                    // Convert to points
                    let points = Gadget.calculatePoints(Int(steps))
                    
                    // Update lastUpdateDate
                    UserDefaults.standard.set(currentDate, forKey: "lastUpdateDate")
                    
                    // Update the day steps
                    
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
                        // There already exists a History object, so check if its for this date
                        
                        let today = results!.first as! History
                        let current = Calendar.current
                        
                        if current.isDateInToday(today.date! as Date) {
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
                            
                            
                            
                            let history = NSEntityDescription.insertNewObject(forEntityName: "History", into: context) as! History
                            history.date = Date()
                            history.steps = Int(steps) as NSNumber?
                            history.points = Double(points) as NSNumber?
                            
                            // update pointsInWallet and totalStepsSinceStart
                            Util.updatePointsInWallet(points)
                            Util.updateTotalPointsSinceStart(points)
                        }
                        
                        do {
                            try context.save()
                        } catch _ {}
                        
                    } else {
                        // There does not exist a History object for this date, so create it
                        
                        let history = NSEntityDescription.insertNewObject(forEntityName: "History", into: context) as! History
                        history.date = Date()
                        history.steps = Int(steps) as NSNumber?
                        history.points = Double(points) as NSNumber?
                        
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
        HKHealthStore().execute(query)
        
    }
    
    /**
     This function is used by HealthKit as the callback for the HKObserverQuery.
     Whenever HealthKit tells this app that there is new data to be requested,
     this function gets called. It calls self.executeHealthKitRequest() to make
     the actual request for the data.
     */
    class func stepChangedHandler(_ query: HKObserverQuery, completionHandler: HKObserverQueryCompletionHandler, error: Error?) {
        
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
        
        let sampleType =  HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        
        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType!, predicate: nil, updateHandler: Util.stepChangedHandler)
        
        HKHealthStore().execute(query)
        HKHealthStore().enableBackgroundDelivery(for: sampleType!, frequency: .immediate, withCompletion: {(succeeded: Bool, error: Error?) in
            
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
    class func updatePointsInWallet(_ change: Double) {
        
        let walletPoints = UserDefaults.standard.value(forKey: "pointsInWallet") as! Double
        let newWalletTotal = walletPoints + change
        
        UserDefaults.standard.setValue(newWalletTotal, forKey: "pointsInWallet")
    }
    
    /**
     This function takes a change in the totalPointsSinceStart variable and adds that change
     to the NSUserDefaults variable. It also fires notifications in two scenarios:
        1. If the user just unlocked a new level
        2. If the user has reached the 50% mark for unlocking the next level
     */
    class func updateTotalPointsSinceStart(_ change: Double) {
        let dashboard = DashboardModel()
        let oldUserLevel = dashboard.getUserLevel()
        
        let totalPoints = UserDefaults.standard.value(forKey: "totalPointsSinceStart") as! Double
        let newTotal = totalPoints + change
        
        UserDefaults.standard.setValue(newTotal, forKey: "totalPointsSinceStart")
        
        let newUserLevel = dashboard.getUserLevel()
        
        if newUserLevel.level > oldUserLevel.level {
            // Create a notification that a new level has been reached!
            
            let notification = UILocalNotification()
            notification.alertBody = "Congrats! You just leveled up to Level \(newUserLevel.level)! Check out the Gadget store to see what you have unlocked!"
            notification.alertAction = "open"
            notification.fireDate = Date(timeIntervalSinceNow: 60)
            notification.soundName = UILocalNotificationDefaultSoundName
            
            UIApplication.shared.scheduleLocalNotification(notification)
            
        } else if oldUserLevel.percentage < 0.5 && newUserLevel.percentage >= 0.5 {
            // Create a notification that they just passed 50% completion of the current level
            
            // Send the notification to the user
            let notification = UILocalNotification()
            notification.alertBody = "You're on a roll! You just reached the half way point to Level \(newUserLevel.level + 1). Keep up the good work!"
            notification.alertAction = "open"
            notification.fireDate = Date(timeIntervalSinceNow: 60)
            notification.soundName = UILocalNotificationDefaultSoundName
            
            UIApplication.shared.scheduleLocalNotification(notification)
            
        }
    }
    
    class func formatNumber(_ number: Double) -> String {
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
