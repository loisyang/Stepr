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

// Insert code here to add functionality to your managed object subclass
    
    func addOne(){
        
        //update coredata
        let app = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context = app.managedObjectContext
        var fetchRequest = NSFetchRequest(entityName: "Gadget")
        fetchRequest.predicate = NSPredicate(format: "name = %@", self.name!)
        do {
            let gadgets = try context.executeFetchRequest(fetchRequest) as! [Gadget]
            if gadgets.count != 0 {
                var gadget = gadgets[0]
                //increase numActive by one
                gadget.setValue(Int(gadget.numActive!) + 1 ,forKey: "numActive")
                try context.save()
                
                //deduct cost from total points
                let walletPoints = NSUserDefaults.standardUserDefaults().valueForKey("pointsInWallet") as! Double
                let newWalletTotal = walletPoints - Double(gadget.cost!)
                NSUserDefaults.standardUserDefaults().setValue(newWalletTotal, forKey: "pointsInWallet")
            }
        } catch {
            fatalError("Failed to fetch gadgets: \(error)")
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
                    bonus += Double(gadget.bonus!)
                }
                
            }
            return Double(newSteps) * bonus
        }
        else{
            return Double(newSteps)
        }
        
    }
}
