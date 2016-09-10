//
//  Util.swift
//  Stepr
//
//  Created by James Ormond on 9/8/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import Foundation

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
            let calendar = NSCalendar.currentCalendar()
            let yesterday = calendar.dateByAddingUnit(.Day, value: -1, toDate: NSDate(), options: [])
            
            NSUserDefaults.standardUserDefaults().setObject(yesterday, forKey: "downloadDate")
            NSUserDefaults.standardUserDefaults().setObject(yesterday, forKey: "lastUpdateDate")
            
            NSUserDefaults.standardUserDefaults().setValue(0, forKey: "totalPointsSinceStart")
            NSUserDefaults.standardUserDefaults().setValue(0.0, forKey: "pointsInWallet")
            NSUserDefaults.standardUserDefaults().setValue(0, forKey: "daySteps")
            NSUserDefaults.standardUserDefaults().setValue(0.0, forKey: "dayPoints")
            
            // Step 2: Build all gadgets into CoreData
            
            // Step 3: Set dataStructureInPlace to true
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "dataStructureInPlace")
        }
    }
    
}