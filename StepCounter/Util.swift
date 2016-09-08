//
//  Util.swift
//  StepCounter
//
//  Created by James Ormond on 9/8/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import Foundation

class Util {
    
    class func initiateDataStructure() {
        // check if data structure has been established
        let established = NSUserDefaults.standardUserDefaults().objectForKey("dataStructureInPlace")
        
        if established == nil {
            // data structure has not been established
            
            // Step 1: Build all NSUserDefaults variables
            let currentDate = NSDate()
            NSUserDefaults.standardUserDefaults().setObject(currentDate, forKey: "downloadDate")
            NSUserDefaults.standardUserDefaults().setObject(currentDate, forKey: "lastUpdateDate")
            
            NSUserDefaults.standardUserDefaults().setValue(0, forKey: "totalPointsSinceStart")
            NSUserDefaults.standardUserDefaults().setValue(0, forKey: "pointsInWallet")
            NSUserDefaults.standardUserDefaults().setValue(0, forKey: "daySteps")
            NSUserDefaults.standardUserDefaults().setValue(0.0, forKey: "dayPoints")
            
            // Step 2: Build all gadgets into CoreData
            
            // Step 3: Set dataStructureInPlace to true
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "dataStructureInPlace")
        }
    }
    
}