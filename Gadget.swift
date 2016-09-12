//
//  Gadget.swift
//  Stepr
//
//  Created by James Ormond on 9/8/16.
//  Copyright © 2016 James Ormond. All rights reserved.
//

import Foundation
import CoreData


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
    
    class func calculatePoints(moc: NSManagedObjectContext, newSteps: Int) -> Double {
        //body
        var bonus:Int = 0
        var gadgetsFetch = NSFetchRequest(entityName: "Gadget")
        do {
            let gadgets = try moc.executeFetchRequest(gadgetsFetch) as! [Gadget]
            for gadget in gadgets {
                bonus += gadget.bonus as! Int
            }
            return Double(newSteps * bonus)
        } catch {
            fatalError("Failed to fetch gadgets: \(error)")
        }
    }
}
