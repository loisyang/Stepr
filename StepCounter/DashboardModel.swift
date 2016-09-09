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
    
    private func updateSteps() {
        
        // Get the lastUpdateDateObject
        let lastDateObject = NSUserDefaults.standardUserDefaults().objectForKey("lastUpdateDate")
        if lastDateObject != nil {
            let lastDate = lastDateObject as! NSDate
            
            let type = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount) // The type of data we are requesting
            
            //  Set the Predicates & Interval
            let interval: NSDateComponents = NSDateComponents()
            interval.day = 1
            
            //  Perform the Query
            let query = HKStatisticsCollectionQuery(quantityType: type!, quantitySamplePredicate: nil, options: [.CumulativeSum], anchorDate: lastDate, intervalComponents:interval)
            
            query.initialResultsHandler = { query, results, error in
                
                if error != nil {
                    
                    //  Something went Wrong
                    return
                }
                
                results?.enumerateStatisticsFromDate(lastDate, toDate: NSDate(), withBlock: {
                    results, error in
                    
                    if let quantity = results.sumQuantity() {
                        
                        let steps = quantity.doubleValueForUnit(HKUnit.countUnit())
                        
                        print("Steps = \(steps)")
                        
                    }
                    
                })
            }

            print("executing")
            self.healthKitStore.executeQuery(query)
            
        } else {
            print("no last update date")
        }
    }
    
}