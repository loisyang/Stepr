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
    
    /**
     This function looks at the totalPointsSinceStart in NSUserDefaults and determines what user
     level that corresponds to. If a level is determined, then an Int representing that level is
     returned; otherwise, 0 is returned, signifying that a level could not be determined. Below
     is the structure of the levels:
     
     Level 1: 0 - 5000
     Level 2: 5000 - 20000
     Level 3: 20000 - 50000
     Level 4: 50000 - 100000
     Level 5: 100000 - 200000
     Level 6: 200000 - 500000
     Level 7: 500000 - 1 mil
     Level 8: 1 mil - 2 mil
     Level 9: 2 mil - 5 mil
     Level 10: 5 mil - 1 bil
     Level 11: 1 bil - 2 bil
     Level 12: 2 bil - 5 bil
     Level 13: 5 bil - 1 tril
     Level 14: 1 tril - 2 tril
     Level 15: 2 tril - 5 tril
     Level 16: 5 tril - 1 quadril
     Level 17: 1 quadril - 2 quadril
     Level 18: 2 quadril - 5 quadril
     Level 19: 5 quadril - 1 pentil
     Level 20: 1 pentil -
     */
    class func determineUserLevel() -> Int {
        let pointsRanges : [[Int]] = []
        
        if let totalPoints = NSUserDefaults.standardUserDefaults().valueForKey("totalPointsSinceStart") {
            let points = totalPoints as! Int
            for level in 0..<pointsRanges.count {
                if pointsRanges[level].contains(points) {
                    return level + 1
                }
            }
        }
        return 0
    }
    
}