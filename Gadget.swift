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
    
    var formattedCost : String {
        let cost = self.cost as! Double
        var short = cost
        var string = ""
        if 1000000 <= cost && cost < 1000000000 {
            short = cost / 1000000
            string = " million"
        } else if 1000000000 <= cost && cost < 1000000000000 {
            short = cost / 1000000000
            string = " billion"
        } else if 1000000000000 <= cost && cost < 1000000000000000 {
            short = cost / 1000000000000
            string = " trillion"
        } else if 1000000000000000 <= cost && cost < 1000000000000000000 {
            short = cost / 1000000000000000
            string = " quadrillion"
        } else if 1000000000000000000 <= cost && cost < 1000000000000000000000 {
            short = cost / 1000000000000000000
            string = " quintillion"
        } else if 1000000000000000000000 <= cost && cost < 1000000000000000000000000 {
            short = cost / 1000000000000000000000
            string = " sextillion"
        } else if 1000000000000000000000000 <= cost && cost < 1000000000000000000000000000 {
            short = cost / 1000000000000000000000000
            string = " septillion"
        } else if 1000000000000000000000000000 <= cost && cost < 1000000000000000000000000000000 {
            short = cost / 1000000000000000000000000000
            string = " octillion"
        } else if 1000000000000000000000000000000 <= cost && cost < 1000000000000000000000000000000000 {
            short = cost / 1000000000000000000000000000000
            string = " nonillion"
        } else if 1000000000000000000000000000000000 <= cost && cost < 1000000000000000000000000000000000000 {
            short = cost / 1000000000000000000000000000000000
            string = " decillion"
        }
        
        if short - Double(Int(short)) == 0 {
            return "\(Int(short))\(string)"
        } else {
            return "\(short)\(string)"
        }
    }
    
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
    
    class func getActiveGadgets() -> [Gadget] {
        let app = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context = app.managedObjectContext
        let request = NSFetchRequest(entityName: "Gadget")
        
        let sortDescriptor = NSSortDescriptor(key: "unlockLevel", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        request.predicate = NSPredicate(format: "numActive > \(0)")
        
        var results : [AnyObject]?
        
        do {
            // Execute the request
            try results = context.executeFetchRequest(request)
        } catch _ {
            results = nil
        }
        
        if results != nil && results!.count > 0 {
           return results as! [Gadget]
        } else {
            return []
        }
    }
}
