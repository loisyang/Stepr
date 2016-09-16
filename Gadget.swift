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
    
    func unlock(moc: NSManagedObjectContext){
        //deduct cost from total points
        //set numActive from 0 to to one
        //update coredata
        var fetchRequest = NSFetchRequest(entityName: "Gadget")
        fetchRequest.predicate = NSPredicate(format: "name = %@", self.name!)
        do {
            let gadgets = try moc.executeFetchRequest(fetchRequest) as! [Gadget]
            if gadgets.count != 0 {
                var gadget = gadgets[0]
                //var one:NSNumber = NSNumber(unsignedShort: 1)
                gadget.setValue(1,forKey: "numActive")
                try moc.save()
            }
        } catch {
            fatalError("Failed to fetch gadgets: \(error)")
        }
    }
    func addOne(){
        //increment numActive for one
        //update coredata
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
            var bonus:Int = 0
            for gadget in gadgets {
                bonus += gadget.bonus as! Int
                print(bonus)
            }
            return Double(newSteps * bonus)
        }
        else{
            return 0
        }
        
    }
}
