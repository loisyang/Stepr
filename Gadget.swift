//
//  Gadget.swift
//  Stepr
//
//  Created by James Ormond on 9/8/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import Foundation
import CoreData
import UIKit
class Gadget: NSManagedObject {
    
    func isUnlocked() -> Bool {
        let dashboard = DashboardModel()
        let userLevel = dashboard.getUserLevel()
        return userLevel.level >= (self.unlockLevel as! Int)
    }
    
    func canPurchase() -> Bool {
        let cost = self.cost as! Double
        let walletPoints = NSUserDefaults.standardUserDefaults().valueForKey("pointsInWallet") as! Double
        return walletPoints >= cost
    }

// Insert code here to add functionality to your managed object subclass
    
    func addOne(){
        
        if self.canPurchase() {
            
            //update coredata
            let app = (UIApplication.sharedApplication().delegate as! AppDelegate)
            let context = app.managedObjectContext
            let fetchRequest = NSFetchRequest(entityName: "Gadget")
            fetchRequest.predicate = NSPredicate(format: "name = %@", self.name!)
            do {
                let gadgets = try context.executeFetchRequest(fetchRequest) as! [Gadget]
                if gadgets.count != 0 {
                    let gadget = gadgets[0]
                    
                    //deduct cost from total points
                    let walletPoints = NSUserDefaults.standardUserDefaults().valueForKey("pointsInWallet") as! Double
                    let newWalletTotal = walletPoints - Double(gadget.cost!)
                    NSUserDefaults.standardUserDefaults().setValue(newWalletTotal, forKey: "pointsInWallet")
                    
                    // modify Gadget
                    // increase numActive by one
                    gadget.setValue(Int(gadget.numActive!) + 1 ,forKey: "numActive")
                    // increase cost by 1.2x
                    gadget.setValue(Int(floor((gadget.cost as! Double) * 1.2)), forKey:  "cost")
                    
                    try context.save()
                }
            } catch {
                fatalError("Failed to fetch gadgets: \(error)")
            }

        }
        
    }
    
    class func calculatePoints(newSteps: Int) -> Double {
        //body
        let app = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context = app.managedObjectContext
        let gadgetsFetch = NSFetchRequest(entityName: "Gadget")
        var results : [AnyObject]?
        do {
            // Execute the request
            try results = context.executeFetchRequest(gadgetsFetch)
            
        } catch  {
            results = nil
        }
        if results != nil && results!.count > 0{
            let gadgets = results! as! [Gadget]
            var bonus:Double = 1
            for gadget in gadgets {
                if (Int(gadget.numActive!) > 0){
                    bonus += Double((gadget.bonus as! Double) * (gadget.numActive as! Double))
                }
                
            }
            return Double(newSteps) * bonus
        }
        else{
            return Double(newSteps)
        }
        
    }
}
