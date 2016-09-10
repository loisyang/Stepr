//
//  DashboardModel.swift
//  Stepr
//
//  Created by James Ormond on 9/9/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import Foundation
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
    
    /**
     This function makes the call to Apple HealthKit and gets all the steps taken since the
     lastUpdateDate. It then updates the appropriate NSUserDefault variables to reflect the
     new data.
     */
    private func updateSteps() {
        
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
                        // NSUserDefaults.standardUserDefaults().setValue(0, forKey: "totalPointsSinceStart")
                        // NSUserDefaults.standardUserDefaults().setValue(0, forKey: "pointsInWallet")
                        // NSUserDefaults.standardUserDefaults().setValue(0.0, forKey: "dayPoints")
                        
                        // Update the day steps
                        let daySteps = NSUserDefaults.standardUserDefaults().objectForKey("daySteps") as! Int
                        NSUserDefaults.standardUserDefaults().setValue(daySteps + Int(steps), forKey: "daySteps")
                        
                        
                    }
                    
                })
            }
            
            // Execute the query
            self.healthKitStore.executeQuery(query)
            
        } else {
            print("no last update date")
        }
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
    
}